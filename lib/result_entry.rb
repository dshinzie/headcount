require "pry"

class ResultEntry

  attr_reader :free_and_reduced_price_lunch_rate,
              :children_in_poverty_rate,
              :high_school_graduation_rate,
              :median_household_income

  def initialize(input_hash)
    @free_and_reduced_price_lunch_rate = input_hash[:free_and_reduced_price_lunch_rate]
    @children_in_poverty_rate = input_hash[:children_in_poverty_rate]
    @high_school_graduation_rate = input_hash[:high_school_graduation_rate]
    @median_household_income = input_hash[:median_household_income]
  end


end
