require_relative 'enrollment'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollment

  def initialize
    @enrollment = {}
  end

  def load_data(data_source)
    filename = data_source.values.reduce({}, :merge!).values.join
    data = {}
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      district_name = row[:location].upcase
      create_hash_data(district_name, data, row)
    end
    @enrollment = data
    data
  end

  def create_hash_data(district_name, data, row)
    create_new_key_for_district(district_name, data)
    add_participation_data_by_year(district_name, data, row)
  end

  def create_new_key_for_district(dist_name, data)
    data[dist_name] = {} unless data.key?(dist_name)
  end

  def add_participation_data_by_year(dist_name, data, row)
    data[dist_name][row[:timeframe].to_i] = clean_participation(row[:data])
  end

  def clean_participation(data)
    data.to_f if number?(data)
  end

  def number?(data)
    data == '0' || data.to_f > 0
  end

  def find_by_name(enrollment)
    @enrollment[enrollment]
  end

  def find_all_matching(search_criteria)
    matching_enrollment = @enrollment.keys.map do |enrollment|
      enrollment if enrollment.include?(search_criteria.upcase)
    end.compact
  end

end
