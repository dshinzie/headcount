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
    filepaths = Loader.extract_filenames(file_hash)
    filepaths.each do |filepath|
      contents = Loader.csv_parse(filepath)
      contents.each do |row|
        add_enrollment(row)
      end
    end
  end

  def add_enrollment(row)
    name = row[:location]
    year = row[:timeframe].to_i
    data = row[:data].to_f

    #if name doesn't exist in hash, create new hash
    #otherwise, add {year => data} combination to kindergarten_participation
    if !find_by_name(name)
      @enrollments[name.upcase] = Enrollment.new( {name: name, kindergarten_participation: {year => data}} )
    else
      enrollment = find_by_name(name) #enrollment instance
      enrollment.kindergarten_participation[year] = data
    end
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end

end
