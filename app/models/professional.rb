class Professional < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_many :professional_services, dependent: :destroy
  has_many :services, through: :professional_services
  has_many :users, through: :appointments
  has_one_attached :photo

  validates :name, :start_at, :finish_at, :role, presence: true
  # need to add photo validation too
end
