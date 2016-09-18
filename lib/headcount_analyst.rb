require 'pry'
require_relative 'district_repository'
require_relative 'sanitizer'

class HeadcountAnalyst
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
    counter = 0
    districts.each do |district|
      counter += 1 if calculate_correlation(district)
    end
    counter.to_f / districts.length.to_f >= 0.70 ? true : false
  end
end
