class TimePeriod < ApplicationRecord
  has_one :season, dependent: :destroy
  has_one :event, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true

  def pretty_year
    "#{year[0..3]} - #{year[4..-1]}"
  end
end