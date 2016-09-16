require_relative 'enrollment_repository'
require_relative 'district'
require_relative 'loader'
require 'csv'
require 'pry'

class DistrictRepository

  attr_reader :districts, :enrollment

  def initialize
    @districts = {}
    @enrollment = EnrollmentRepository.new
  end

  def load_data(file_hash)
    load_data_district(file_hash)
    @enrollment.load_data(file_hash)
    # @statewide_repository.load_data(file_hash)
    link_enrollments
  end

  def load_data_district(file_hash)
    filepaths = Loader.extract_filenames(file_hash)
    filepaths.each do |filepath|
      contents = Loader.csv_parse(filepath)
      contents.each do |row|
        add_district(row)
      end
    end
  end

  def add_district(row)
    name = row[:location].upcase
    @districts[name] ||= District.new( { name: name } )
  end

  def find_by_name(name)
    @districts[name]
  end

  def find_all_matching(search_criteria)
    @districts.select do |name, district| #key, value
      name.include?(search_criteria.upcase)
    end.values
  end

  def link_enrollments
    e = @enrollment.enrollments
    e.each do |name, enrollment_object|
      find_by_name(name).enrollment = enrollment_object
    end
  end

end
