class Owner::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_owner!

  def index
    @appointments = Appointment.all
  end

  def show_appointments

    date = params[:date]
    @appointments = Appointment.where(date: date)

    render partial: "appointments_list", locals: { appointments: @appointments }
  end

  private

  def require_owner!
    redirect_to authenticated_root_path unless current_user.owner?
  end
end
