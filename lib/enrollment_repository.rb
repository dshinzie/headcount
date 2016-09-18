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
    Loader.load_data_enrollment(file_hash, @enrollments)
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end
  
end
