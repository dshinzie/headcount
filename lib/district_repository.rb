require 'csv'
require 'pry'
require_relative 'enrollment_repository'
require_relative 'district'

class DistrictRepository

  attr_reader :districts, :enrollment

  def initialize
    @districts = {}
    @enrollment = EnrollmentRepository.new
  end

  def load_data(file_hash)
    load_all(file_hash)
  end

  def load_all(file_hash)
    load_data_district(file_hash)
    @enrollment.load_data(file_hash)
    binding.pry
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

  # def load_data(file_hash)
  #   filename = file_hash[:enrollment][:kindergarten]
  #   CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
  #     add_district(row)
  #   end
  # end

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
