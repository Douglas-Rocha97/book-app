class Service < ApplicationRecord
  has_many :professionals, through: :professionals_services
  has_many :professional_services

  validates :name, :price, :duration, presence: true
end
