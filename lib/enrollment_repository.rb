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
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      district_name = row[:location].upcase
      @enrollment[district_name] ||= {}
      @enrollment[dist_name][row[:timeframe].to_i] = clean_participation(row[:data])
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
