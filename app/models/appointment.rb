class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :professional

  has_one_attached :goal_image

  has_many :appointment_services, dependent: :destroy
  has_many :services, through: :appointment_services


  validates :date, :start_time, :finish_time, presence: true
  validate :must_have_at_least_one_service

  private

  def must_have_at_least_one_service
    if services.empty?
      errors.add(:services, "You need to select at least one service")
    end
  end

end
