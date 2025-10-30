class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :professional

  has_one_attached :goal_image

  has_many :appointment_services, dependent: :destroy
  has_many :services, through: :appointment_services


  validates :date, :start_time, :finish_time, presence: true

end
