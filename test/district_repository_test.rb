require_relative 'test_helper'
require_relative '../lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_district_repository_initializes_with_empty_hash
    dr = DistrictRepository.new

    assert_equal ({}), dr.districts
  end

  def test_districts_hash_is_populated_after_loading
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    refute dr.districts.nil?
  end

  def test_districts_loads_from_single_file
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |district| assert dr.districts.keys.include?(district.upcase)}
  end

  def test_find_by_name_returns_district_instance
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |district| assert dr.find_by_name(district.upcase).instance_of?(District) }
  end

  def test_find_all_returns_all_matching_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    assert_equal 2, dr.find_all_matching('Col').length
    assert_equal 8, dr.find_all_matching('AD').length
  end

  def test_enrollment_is_linked_after_loading
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']

    test_list.each { |name| assert dr.districts.values.find{|district| district.enrollment.name == name.upcase }}
    #dr.districts.values.each {|district| refute district.enrollment.nil?}
  end

  def test_statewide_test_is_linked_after_loading
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']

    test_list.each { |name| assert dr.districts.values.find{|district| district.statewide_test.name == name.upcase }}
    #dr.districts.values.each {|district| refute district.statewide_test.nil?}

  end

end
