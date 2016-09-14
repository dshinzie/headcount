require 'csv'
require 'pry'
require_relative 'enrollment'
require_relative 'district'

class DistrictRepository

  attr_reader :districts

  def initialize
    @districts = {}
    @enrollment_repository = EnrollmentRepository.new
  end

  def load_data(data_source)
    filename = data_source[:enrollment][:kindergarten]
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      add_district(row)
    end
  end

  def add_district(row)
    name = row[:location].upcase
    @districts[name] = District.new( { name: name } ) if !find_by_name(name)
  end

  def find_by_name(name)
    @districts[name]
  end

  def find_all_matching(search_criteria)
    result = @districts.select do |name, district| #key, value
      district if name.include?(search_criteria.upcase)
    end.values
  end
  
end


#write a method that triggers the load_file method in EnrollmentRepository
#use district class to access enrollment information
