require 'date'

module ApplicationHelper
  def years_between(earlier_date:, later_date:)
    # Calculate the difference in years.
    year_diff = later_date.year - earlier_date.year
    
    # Adjust if the later date is before the anniversary of the earlier date in the same year.
    year_diff -= 1 if later_date < earlier_date.next_year(year_diff)
    
    year_diff
  end
end
