require 'pry'
require_relative 'district_repository'
require_relative 'sanitizer'

class HeadcountAnalyst
  attr_accessor :dr, :rate_trend

  def initialize(district_repository)
    @dr = district_repository
    @rate_trend = {}
  end

  def kindergarten_participation_rate_variation(district, location)
    name = location[:against]

    district_average = find_average_participation(district)
    location_average = find_average_participation(name)

    rate_variation = Sanitizer.truncate(district_average/location_average)
  end

  def find_average_participation(name)
    results = @dr.enrollment.enrollments[name].kindergarten_participation.values
    average = results.reduce(0) {|sum, rate| sum += rate}.to_f / results.size
    Sanitizer.truncate(average)
  end

  def kindergarten_participation_rate_variation_trend(district, location)
    name = location[:against]
    build_variation_trend_hash(district, name, true)
  end

  def build_variation_trend_hash(district, location, first_run)
    if first_run
      results = @dr.enrollment.enrollments[district].kindergarten_participation
      results.each do |key, value|
        @rate_trend[key] = value
      end
      first_run = false
      build_variation_trend_hash(district, location, false)
    else
      results = @dr.enrollment.enrollments[location].kindergarten_participation
      results.each do |key, value|
        @rate_trend[key] = Sanitizer.truncate(@rate_trend[key]/value)
      end
    end
    @rate_trend.sort.to_h
  end

end
