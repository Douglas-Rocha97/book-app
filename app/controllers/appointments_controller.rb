# https://dribbble.com/shots/26251511-Barber-Booking-App
# https://dribbble.com/shots/25508922-Barber-Booking-Mobile-App
class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.all
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy

    redirect_back(fallback_location: appointments_path, notice: "Appointment Deleted")
  end
end
