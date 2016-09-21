require_relative 'loader'

class EnrollmentRepository
  include Loader

  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(file_hash)
    load_data_enrollment(file_hash, @enrollments)
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end

end
