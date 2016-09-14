require_relative 'enrollment'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(data_source)
    filename = data_source[:enrollment][:kindergarten]
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      add_enrollment(row)
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
