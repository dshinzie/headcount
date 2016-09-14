require_relative 'enrollment'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollment

  def initialize
    @enrollment = {}
  end

  def load_data(data_source)
    data = {}
    filename = data_source.values.reduce({}, :merge!).values.join
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      district_name = row[:location].upcase
      data[district_name] ||= {}
      data[district_name][row[:timeframe].to_i] = clean_participation(row[:data])
    end
    create_enrollment_objects(data)
  end

  def create_enrollment_objects(enrollment_data)
    enrollment_data.each do |district, data|
      e = Enrollment.new({:name => district, :kindergarten_participation => data})
      @enrollment[district] = e
    end
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
end
