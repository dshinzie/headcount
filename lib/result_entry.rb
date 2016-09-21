class ResultEntry

  attr_reader :free_and_reduced_price_lunch_rate,
              :children_in_poverty_rate,
              :high_school_graduation_rate,
              :median_household_income,
              :name

  def initialize(input_hash)
    @free_and_reduced_price_lunch_rate =
    input_hash[:free_and_reduced_price_lunch_rate]
    @children_in_poverty_rate = input_hash[:children_in_poverty_rate]
    @high_school_graduation_rate = input_hash[:high_school_graduation_rate]
    @median_household_income = input_hash[:median_household_income]
    @name = input_hash[:name]
  end

  def poverty_hs_state_comp(re)
    self.free_and_reduced_price_lunch_rate >
    re.free_and_reduced_price_lunch_rate &&
    self.children_in_poverty_rate > re.children_in_poverty_rate &&
    self.high_school_graduation_rate > re.high_school_graduation_rate
  end

  def income_state_comp(re)
    self.children_in_poverty_rate > re.children_in_poverty_rate &&
    self.median_household_income > re.median_household_income
  end

end
