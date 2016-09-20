require 'pry'
require_relative 'district_repository'
require_relative 'economic_profile_repository'
require_relative 'sanitizer'
require_relative 'result_entry'
require_relative 'result_set'


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
    kindergarten_variation =
    kindergarten_participation_rate_variation(district, :against => "COLORADO")
    graduation_variation =
    high_school_participation_rate_variation(district, :against => "COLORADO")

    graduation_variation == 0 ? 0 :
    Sanitizer.truncate(kindergarten_variation / graduation_variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(loc)
    if loc.has_key? :across
      calculate_percentage_correlated(loc[:across])
    elsif loc[:for].upcase != 'STATEWIDE'
      calculate_correlation(loc[:for])
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
    statewide = statewide_average()
    results = []
    @dr.districts.keys.each do |district_name|
      result_entry = district_result_entry(district_name)
      results << result_entry if result_entry.bigger_than(statewide)
    end
    ResultSet.new(matching_districts: results, statewide_average: statewide)
  end

  def district_result_entry(district_name)
    ResultEntry.new({
      free_and_reduced_price_lunch_rate: get_lunch_average(district_name),
      children_in_poverty_rate: get_poverty_average(district_name),
      high_school_graduation_rate:
      get_average_hs_graduation_rate(district_name),
      name: district_name})
  end

  def statewide_average
    ResultEntry.new({
      free_and_reduced_price_lunch_rate: get_lunch_average(),
      children_in_poverty_rate: get_statewide_poverty,
      high_school_graduation_rate: get_average_hs_graduation_rate,
      name: 'COLORADO' })
  end

  def get_average_hs_graduation_rate(district_name = 'COLORADO')
    district = @dr.find_by_name(district_name)
    all_years = district.enrollment.high_school_graduation_participation.values
    total = all_years.reduce(:+)
    total = total / all_years.count
    total = total / @dr.districts.keys.count if district_name == 'COLORADO'
    total
  end

  def get_statewide_poverty
    district_names = @dr.districts.keys
    count = 0
    total = 0
    district_names.each do |district_name|
      avg = get_poverty_average(district_name)
      unless avg.nil?
        count += 1
        total += avg
      end
    end
    total / count
  end

  def get_poverty_average(district_name)
    district = @dr.find_by_name(district_name)
    all_data = district.economic_profile.children_in_poverty.values
    return nil if all_data.count == 0
    all_data.reduce(:+) / all_data.size
  end

  def get_lunch_average(district_name = "COLORADO")
    district = @dr.find_by_name(district_name)
    all_data = district.economic_profile.free_or_reduced_price_lunch.values
    return nil if all_data.count == 0
    total = all_data.map { |data| data[:total] } .reduce(:+)
    total = total / all_data.size
    total = total / @dr.districts.keys.count if district_name == 'COLORADO'
    total
  end
end
