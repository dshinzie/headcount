require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require "csv"

module Loader
  extend self

  attr_reader :d, :e, :st, :test

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
    @d = districts
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
    @e = enrollments
  end

  def load_data_statewide(file_hash, statewide_tests)
    category_hash = file_hash[:statewide_testing]
    category_hash.each do |category, filepath|
      #category = key.to_sym
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
    @st = statewide_tests
  end

  def add_testing_by_ethnicity(row, category, statewide_tests)
    name = row[:location]
    race = Sanitizer.sanitize_symbols(row[:race_ethnicity])
    year = row[:timeframe].to_i
    data = row[:data].to_f

    statewide_tests[name.upcase] ||= StatewideTest.new({name: name })
    statewide_tests[name.upcase].instance_variable_set("@#{race}", {}) if !statewide_tests[name.upcase].instance_variable_defined?("@#{race}")
    statewide_tests[name.upcase].send(race)[year] ||= {}
    statewide_tests[name.upcase].send(race)[year][category] = data
    @st = statewide_tests
  end

end
