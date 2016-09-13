require_relative 'district'
require 'csv'
require 'pry'
#require 'enrollment'

class DistrictRepository

  attr_reader :districts

  def initialize
    @districts = {}
  end

  def load_data(data_source)
    # validate and send to enrollment class
    # enrollment class populates district array with enrollment districts
    # create new districts class instance with new district data pulled from enrollment class
    filename = data_source.values.reduce({}, :merge!).values.join
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      #district_name = row[:location].upcase

      district = District.new(row)
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


end
