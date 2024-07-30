class TimePeriod < ApplicationRecord
  has_one :season, dependent: :destroy
  has_one :event, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true
end