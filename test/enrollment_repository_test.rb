require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_enrollment_hash_is_populated_after_loading
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./fixture/Kindergartners in full-day program clean.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")

    refute er.enrollment.nil?
  end

  def test_enrollment_loads_from_single_file
    skip
    dr = EnrollmentRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    expected = ['Colorado', 'ACADEMY 20', 'Agate 300']
    expected.each { |district| assert dr.enrollment.keys.include?(district.upcase)}
  end

  def test_find_by_name_returns_district_instance
    skip
    dr = EnrollmentRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |district| assert dr.find_by_name(district.upcase).instance_of?(District) }
  end

  def test_find_all_returns_all_closest_enrollment
    skip
    dr = EnrollmentRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    expected = ['COLORADO', 'COLORADO SPRINGS 11']
    assert_equal expected, dr.find_all_matching('Col')

  end



end
