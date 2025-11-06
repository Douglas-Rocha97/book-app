# https://dribbble.com/shots/26251511-Barber-Booking-App
# https://dribbble.com/shots/25508922-Barber-Booking-Mobile-App
class AppointmentsController < ApplicationController
  def index
    @appointments = current_user.appointments
  end

  def new
    @appointment = Appointment.new
    @services = Service.all
    @professionals = Professional.all
  end

  def create
    @appointment_params = appointment_params

    professional = Professional.find(@appointment_params[:professional_id])
    services_ids = @appointment_params[:service_ids].reject(&:blank?)
    services = Service.where(id: services_ids)

    total_duration = services.sum(&:duration)

    date = Date.parse(@appointment_params[:date])
    start_time = Time.zone.parse(@appointment_params[:start_time])

    start_at = Time.zone.local(date.year, date.month, date.day, start_time.hour, start_time.min)
    finish_at = start_at + total_duration.minutes

    @appointment = Appointment.new(
      user: current_user,
      professional: professional,
      date: date,
      start_time: start_at,
      finish_time: finish_at
    )

    if @appointment_params[:photo].present?
      @appointment.goal_image.attach(@appointment_params[:photo])
    end

    if @appointment.save
      @appointment.services << services
      redirect_to appointments_path
    else
      puts @appointment.errors.full_messages
      @services = Service.all
      @professionals = Professional.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment = current_user.appointments.find(params[:id])
    @appointment.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to appointments_path }
    end
  end

  def available_times
    begin
      professional = Professional.find(params[:professional_id])
    rescue ActiveRecord::RecordNotFound
      return render json: { error: "Professional not found" }, status: :not_found
    end

    begin
      date = Date.parse(params[:date].to_s)
    rescue ArgumentError
      return render json: { error: "Invalid date" }, status: :bad_request
    end

    # garante que service_ids virá como array e remove strings vazias/nulos
    service_ids = Array(params[:service_ids]).map(&:to_s).reject(&:blank?).map(&:to_i)
    if service_ids.empty?
      return render json: { error: "No services provided" }, status: :bad_request
    end

    # soma as durações dos serviços selecionados (assume coluna `duration` em minutos)
    total_duration_minutes = Service.where(id: service_ids).sum(:duration)
    total_duration = total_duration_minutes.minutes

    # Constrói start_time e finish_time no fuso da aplicação, com a data escolhida
    # Tratamos professional.start_at podendo ser Time, String ou ActiveSupport::TimeWithZone
    start_at_value = professional.start_at
    finish_at_value = professional.finish_at

    start_time =
      if start_at_value.respond_to?(:hour)
        # se for Time/TimeWithZone/DateTime
        date.in_time_zone.change(hour: start_at_value.hour, min: start_at_value.min)
      else
        # se for "09:00" string
        Time.zone.parse("#{date} #{start_at_value}")
      end

    finish_time =
      if finish_at_value.respond_to?(:hour)
        date.in_time_zone.change(hour: finish_at_value.hour, min: finish_at_value.min)
      else
        Time.zone.parse("#{date} #{finish_at_value}")
      end

    # Gera slots de 30 minutos (ajuste se quiser outro intervalo)
    slot_interval = 30.minutes
    all_slots = []
    current = start_time

    # criamos slots que cabem inteiramente no expediente (current + total_duration <= finish_time)
    while (current + total_duration) <= finish_time
      all_slots << current
      current += slot_interval
      # safety guard infinito (não precisa em geral)
      break if all_slots.size > 1000
    end

    # busca appointments do dia e profissional com includes(:services)
    appointments = Appointment.includes(:services).where(professional: professional, date: date)

    # remove slots que conflitam com qualquer appointment existente
    appointments.each do |appt|
      # se appt.start_time for Time completo (com data), usamos ele; se for só hora, construímos com date
      appt_start =
        if appt.start_time.respond_to?(:to_time) && appt.start_time.to_time.year > 2000
          appt.start_time.in_time_zone
        else
          Time.zone.parse("#{date} #{appt.start_time.strftime("%H:%M") rescue appt.start_time}")
        end

      appt_duration_minutes = appt.services.sum(:duration)
      appt_end = appt_start + appt_duration_minutes.minutes

      all_slots.reject! do |slot|
        slot_end = slot + total_duration
        # overlap test: [slot, slot_end) x [appt_start, appt_end)
        (slot < appt_end) && (slot_end > appt_start)
      end
    end

    # remove horários que já passaram se a data for hoje
    if date == Date.current
      now = Time.current
      all_slots.reject! { |slot| slot <= now }
    end

    if all_slots.empty?
      return render json: { message: "No available times. Please choose another date." }, status: :ok
    end

    # formata em strings "HH:MM" e retorna JSON
    render json: all_slots.map { |t| t.strftime("%H:%M") }
  end

  private

  def appointment_params
    params.require(:appointment).permit(:professional_id, :date, :start_time, :photo, service_ids: [])
  end
end
