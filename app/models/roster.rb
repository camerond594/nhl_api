class Roster < ApplicationRecord
  belongs_to :team
  has_many :roster_assignments, dependent: :destroy
  has_many :players, through: :roster_assignments

  validates :year, presence: true

  def name
    year[0..3] + " - " + year[4..-1]
  end

  def grouped_roster
    players.order(
      Arel.sql("
        CASE position 
          WHEN 'L' THEN 1 
          WHEN 'C' THEN 2 
          WHEN 'R' THEN 3 
          WHEN 'D' THEN 4 
          WHEN 'G' THEN 5 
          ELSE 6 
        END
      ")
    )
  end
end