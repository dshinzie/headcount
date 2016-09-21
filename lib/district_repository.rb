require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'
require_relative 'loader'

class DistrictRepository
  include Loader

  attr_reader :districts, :enrollment, :statewide_test, :economic_profile

  def initialize
    @districts = {}
    @enrollment = EnrollmentRepository.new
    @statewide_test = StatewideTestRepository.new
    @economic_profile = EconomicProfileRepository.new
  end

  def load_data(file_hash)
    load_data_district(file_hash, @districts)
    keys = file_hash.keys
    @enrollment.load_data(file_hash) if keys.include?(:enrollment)
    @statewide_test.load_data(file_hash) if keys.include?(:statewide_testing)
    @economic_profile.load_data(file_hash) if keys.include?(:economic_profile)
    link_enrollments
    link_statewide_tests
    link_economic_profiles
  end

  def find_by_name(name)
    @districts[name]
  end

  def find_all_matching(search_criteria)
    @districts.select do |name, district| #key, value
      name.include?(search_criteria.upcase)
    end.values
  end

  def link_enrollments
    e = @enrollment.enrollments
    e.each do |name, enrollment_object|
      find_by_name(name).enrollment = enrollment_object
    end
  end

  def link_statewide_tests
    st = @statewide_test.statewide_tests
    st.each do |name, statewide_object|
      find_by_name(name).statewide_test = statewide_object
    end
  end

  def link_economic_profiles
    ep = @economic_profile.economic_profiles
    ep.each do |name, economic_object|
      find_by_name(name).economic_profile = economic_object
    end
  end

end
