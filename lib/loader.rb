require_relative 'district'
require_relative 'enrollment'
require_relative 'statewide_test'
require_relative 'economic_profile'
require_relative 'sanitizer'
require "csv"
require 'pry'

module Loader
  extend self

  attr_reader :d, :e, :st, :ep

  def extract_filenames(file_hash)
    filepaths = file_hash.values.map { |hash| hash.values}
    filepaths.flatten!
  end

  def csv_parse(filepath)
    CSV.open(filepath, headers: true, header_converters: :symbol)
  end

  def load_data_district(file_hash, districts)
    filepaths = Loader.extract_filenames(file_hash)
    filepaths.each do |filepath|
      contents = Loader.csv_parse(filepath)
      contents.each do |row|
        add_district(row, districts)
      end
    end
  end

  def add_district(row, districts)
    name = row[:location].upcase
    districts[name] ||= District.new( { name: name } )
  end

  def load_data_enrollment(file_hash, enrollments)
    school_level_hash = file_hash[:enrollment]
    school_level_hash.each do |key, filepath|
      category = key.to_s + "_participation"
      contents = Loader.csv_parse(filepath)
      contents.each do |row|
        add_enrollment(row, category, enrollments)
      end
    end
  end

  def add_enrollment(row, category, enrollments)
    name = row[:location]
    year = row[:timeframe].to_i
    data = row[:data].to_f

    enrollments[name.upcase] ||= Enrollment.new({name: name })
    enrollments[name.upcase].send(category)[year] = data
  end

  def load_data_statewide(file_hash, statewide_tests)
    category_hash = file_hash[:statewide_testing]
    category_hash.each do |category, filepath|
      contents = Loader.csv_parse(filepath)
      contents.each do |row|
        if category == :third_grade || category == :eighth_grade
          add_testing_by_proficiency(row, category, statewide_tests)
        else
          add_testing_by_ethnicity(row, category, statewide_tests)
        end
      end
    end
    statewide_tests
  end

  def add_testing_by_proficiency(row, category, statewide_tests)
    name = row[:location]
    proficiency = Sanitizer.sanitize_symbols(row[:score])
    year = row[:timeframe].to_i
    data = row[:data].to_f

    statewide_tests[name.upcase] ||= StatewideTest.new({name: name })
    statewide_tests[name.upcase].send(category)[year] ||= {}
    statewide_tests[name.upcase].send(category)[year][proficiency] = data
  end

  def add_testing_by_ethnicity(row, category, statewide_tests)
    name = row[:location]
    race = Sanitizer.sanitize_symbols(row[:race_ethnicity])
    year = row[:timeframe].to_i
    data = row[:data].to_f

    statewide_tests[name.upcase] ||= StatewideTest.new({name: name })

    statewide_tests[name.upcase].send(race)[year] ||= {}
    statewide_tests[name.upcase].send(race)[year][category] = data
  end

  def load_data_economic(file_hash, economic_profiles)
    category_hash = file_hash[:economic_profile]
    category_hash.each do |category, filepath|
      contents = Loader.csv_parse(filepath)
      contents.each do |row|
        if category == :free_or_reduced_price_lunch
          add_reduced_price_lunch(row, category, economic_profiles)
        elsif row[:dataformat].downcase != 'number' #come back to this
          add_income_poverty_title(row, category, economic_profiles)
        end
      end
    end
  end

  def add_income_poverty_title(row, category, economic_profiles)
    name = row[:location]
    year = Sanitizer.sanitize_years(row[:timeframe])
    data = row[:data].to_f

    economic_profiles[name.upcase] ||= EconomicProfile.new({name: name})
    economic_profiles[name.upcase].send(category)[year] ||= {}
    economic_profiles[name.upcase].send(category)[year] = data
  end

  def add_reduced_price_lunch(row, category, economic_profiles)
    name = row[:location]
    year = Sanitizer.sanitize_years(row[:timeframe])
    percent = row[:data].to_f if row[:dataformat].downcase == 'percent'
    total = row[:data].to_i if row[:dataformat].downcase == 'number'
    poverty_level = row[:poverty_level].downcase

    if poverty_level.include?('free or reduced')
      economic_profiles[name.upcase] ||= EconomicProfile.new({name: name})
      economic_profiles[name.upcase].send(category)[year] ||= {}
      economic_profiles[name.upcase].send(category)[year][:percentage] =
      percent unless percent.nil?
      economic_profiles[name.upcase].send(category)[year][:total] =
      total unless total.nil?
    end
  end

end
