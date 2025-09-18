class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :professional

  validates :date, :start_time, :finish_time, presence: true
end
