class Service < ApplicationRecord
  has_many :professionals, through: :professionals_services
  has_many :professional_services
  has_many :appointment_services
  has_many :appointments, through: :appointment_services
  validates :name, :price, :duration, presence: true
end
