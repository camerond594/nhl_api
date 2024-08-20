class Season < ApplicationRecord
  belongs_to :time_period
  accepts_nested_attributes_for :time_period

  validates :time_period, presence: true

  def year
    "#{time_period.year[0..3]} - #{time_period.year[4..-1]}"
  end
end