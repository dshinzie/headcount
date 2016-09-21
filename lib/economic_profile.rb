require_relative 'custom_errors'
require_relative 'sanitizer'

class EconomicProfile
  include Sanitizer

  attr_reader :name,
              :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i

  def initialize(input_hash)
    @name = input_hash[:name].upcase || {} if !input_hash[:name].nil?
    @median_household_income = input_hash[:median_household_income] || {}
    @children_in_poverty = input_hash[:children_in_poverty] || {}
    @free_or_reduced_price_lunch =
    input_hash[:free_or_reduced_price_lunch] || {}
    @title_i = input_hash[:title_i] || {}
  end

  def median_household_income_in_year(year)
    raise UnknownDataError unless median_household_income.keys.find do |years|
      years.include?(year)
    end

    count = 0
    median_household_income.inject(0) do |sum, (k, v)|
      range = (k.first..k.last).to_a
      count += 1 if range.include?(year)
      sum += v if range.include?(year)
      sum
    end / count
  end

  def median_household_income_average
    median_household_income.reduce(0) do |sum, (k, v)|
      sum += v
    end / median_household_income.keys.count
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError unless children_in_poverty.keys.include?(year)

    truncate(children_in_poverty[year])
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError unless
    free_or_reduced_price_lunch.keys.include?(year)

    free_or_reduced_price_lunch[year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError unless
    free_or_reduced_price_lunch.keys.include?(year)

    free_or_reduced_price_lunch[year][:total]
  end

  def title_i_in_year(year)
    raise UnknownDataError unless title_i.keys.include?(year)

    title_i[year]
  end

end
