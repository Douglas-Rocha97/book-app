class Professional < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :users, through: :appointments
  has_one_attached :photo

  validates :name, :photo, :start_at, :finish_at, :role, presence: true
end
