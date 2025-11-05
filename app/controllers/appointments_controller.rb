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
    professional = Professional.find(params[:professional_id])
    date = Date.parse(params[:date])

    start_time = professional.start_at
    finish_time = professional.finish_at

    all_times = []
    current = start_time
    while current < finish_time
      all_times << current.strftime("%H:%M")
      current += 30.minutes
    end

    booked_times = Appointment
    .where(professional: professional, date: date)
    .pluck(:start_time)

    available = all_times - booked_times

    render json: available
  end

  private

  def appointment_params
    params.require(:appointment).permit(:professional_id, :date, :start_time, :photo, service_ids: [])
  end
end
