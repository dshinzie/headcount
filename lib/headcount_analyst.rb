require 'pry'
require_relative 'district_repository'
require_relative 'economic_profile_repository'
require_relative 'sanitizer'

class HeadcountAnalyst
  include Sanitizer
  attr_accessor :dr

  def initialize(district_repository)
    @dr = district_repository
  end

  def kindergarten_participation_rate_variation(district, location)
    name = location[:against]
    find_rate_variation(district, name, :kindergarten_participation)
  end

  def high_school_participation_rate_variation(district, location)
    name = location[:against]
    find_rate_variation(district, name, :high_school_graduation_participation)
  end

  def find_rate_variation(district, name, grade_level)
    district_average = find_average_participation(district, grade_level)
    location_average = find_average_participation(name, grade_level)
    Sanitizer.truncate(district_average/location_average)
  end

  def find_average_participation(name, grade_level)
    results = @dr.find_by_name(name).enrollment.send(grade_level).values
    average = results.reduce(0) {|sum, rate| sum += rate}.to_f / results.size
    Sanitizer.truncate(average)
  end

  def kindergarten_participation_rate_variation_trend(district, location)
    name = location[:against]
    build_variation_trend_hash(district, name)
  end

  def build_variation_trend_hash(district_1_name, district_2_name)
    e1 = @dr.find_by_name(district_1_name).enrollment.kindergarten_participation
    e2 = @dr.find_by_name(district_2_name).enrollment.kindergarten_participation
    variation_hash = {}
    e1.keys.each do |year|
      variation_hash[year] = Sanitizer.truncate(e1[year] / e2[year])
    end
    variation_hash
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kindergarten_variation = kindergarten_participation_rate_variation(district, :against => "COLORADO")
    graduation_variation = high_school_participation_rate_variation(district, :against => "COLORADO")

    graduation_variation == 0 ? 0 : Sanitizer.truncate(kindergarten_variation / graduation_variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(location)
    if location.has_key? :across
      calculate_percentage_correlated(location[:across])
    elsif location[:for].upcase != 'STATEWIDE'
      calculate_correlation(location[:for])
    else
      calculate_percentage_correlated(@dr.districts.keys)
    end
  end

  def calculate_correlation(name)
    variation = kindergarten_participation_against_high_school_graduation(name)
    variation.between?(0.6, 1.5)
  end

  def calculate_percentage_correlated(districts)
    total_true = districts.map do |district|
      calculate_correlation(district)
    end
    (total_true.count(true) / total_true.count) >= 0.70
  end

  def high_poverty_and_high_school_graduation
    #Above the statewide average in number of students qualifying for free and reduced price lunch
    # Above the statewide average percentage of school-aged children in poverty
    # Above the statewide average high school graduation rate
  end

  def district_against_state_poverty_variation
    districts_high_poverty = []

    # state_average_percent = find_average_free_reduced_lunch("COLORADO", :percentage)
    state_average = get_average_lunch("COLORADO", :total)
    binding.pry

    dr.districts.keys.each do |district|
      district_average = get_average_lunch(district, :total)
      districts_high_poverty << district if district_average > state_average
    end
    districts_high_poverty
    binding.pry
  end

  def get_average_lunch(district, data_type)
    district = @dr.find_by_name(district)
    results = district.economic_profile.free_or_reduced_price_lunch.values

    return truncate(results.map { |x| x[data_type].to_f }.reduce(:+) / results.size) if district.name.upcase != "COLORADO"
    return truncate(results.map { |x| x[data_type].to_f }.reduce(:+) / results.size / @dr.districts.size) if district.name.upcase == "COLORADO"
  end


end
