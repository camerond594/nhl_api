class Event < ApplicationRecord
  belongs_to :time_period
  accepts_nested_attributes_for :time_period

  validates :time_period, presence: true
end