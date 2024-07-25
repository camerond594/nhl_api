class Team < ApplicationRecord
  has_many :rosters, dependent: :destroy
end