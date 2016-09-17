require_relative 'statewide_testing'
require_relative 'loader'
require 'csv'
require 'pry'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @statewide_tests = {}
  end

  def load_data(file_hash)
    school_level_hash = file_hash[:statewide_testing]
    school_level_hash.each do |key, filepath|
      school_level = key.to_s
      contents = Loader.csv_parse(filepath)
      contents.each do |row|
        if school_level == "third_grade" || school_level == "eighth_grade"
          add_testing_by_proficiency(row, school_level)
          else
            add_testing_by_ethnicity(row, school_level)
        end
      end
    end
  end

  def add_testing_by_proficiency(row, school_level)
    name = row[:location]
    proficiency = row[:score]
    year = row[:timeframe].to_i
    data = row[:data].to_f

    @statewide_tests[name.upcase] ||= StatewideTest.new({name: name })
    @statewide_tests[name.upcase].send(school_level)[year] ||= {}
    @statewide_tests[name.upcase].send(school_level)[year][proficiency] = data
  end

  def add_testing_by_ethnicity(row, school_level)
    name = row[:location]
    race = row[:race_ethnicity]
    year = row[:timeframe].to_i
    data = row[:data].to_f

    @statewide_tests[name.upcase] ||= StatewideTest.new({name: name })
    @statewide_tests[name.upcase].send(school_level)[year] = { race => data}
  end

  def find_by_name(name)
    @statewide_tests[name.upcase]
  end
end
