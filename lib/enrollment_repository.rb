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
    school_level_hash = get_school_level_hashes(file_hash)
    school_level_hash.each do |key, value|
      school_level = key.to_s + "_participation"
      filepath = value
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
    school_symbol = school_level

    #if name doesn't exist in hash, create new hash
    #otherwise, add {year => data} combination to kindergarten_participation
    if !find_by_name(name)
      @enrollments[name.upcase] = Enrollment.new( {name: name, school_symbol.to_sym => {year => data}} )
    else
      enrollment = find_by_name(name) #enrollment instance
      enrollment.send(school_level)[year] = data
    end
  end

  def get_school_level_hashes(file_hash)
    file_hash.values.reduce
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end

end
