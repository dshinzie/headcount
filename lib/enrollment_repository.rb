require_relative 'enrollment'
require_relative 'loader'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(file_hash)
    school_level_hash = file_hash[:enrollment]
    school_level_hash.each do |key, filepath|
      school_level = key.to_s + "_participation"
      contents = Loader.csv_parse(filepath)
      contents.each do |row|
        add_enrollment(row, school_level)
      end
    end
  end

  def add_enrollment(row, school_level)
    name = row[:location]
    year = row[:timeframe].to_i
    data = row[:data].to_f

    @enrollments[name.upcase] ||= Enrollment.new({name: name })
    @enrollments[name.upcase].send(school_level)[year] = data
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end
end
