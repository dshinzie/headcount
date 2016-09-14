require 'csv'
require 'pry'
require './lib/enrollment'
require './lib/district'

class DistrictRepository

  attr_reader :districts

  def initialize
    @districts = {}
    @enrollment_repository = EnrollmentRepository.new
  end

  def load_data(data_source)
    filename = data_source.values.reduce({}, :merge!).values.join
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      district = District.new(name: row[:location])
      @districts[district.name] = district
    end
  end

  def find_by_name(district)
    @districts[district]
  end

  def find_all_matching(search_criteria)
    matching_districts = @districts.keys.map do |district|
      district if district.include?(search_criteria.upcase)
    end.compact
  end

  #write a method that triggers the load_file method in EnrollmentRepository
  #use district class to access enrollment information

end
