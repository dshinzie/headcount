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

  def test_district_repository_adds_to_hash
    dr = DistrictRepository.new

    dr.add_district( {:location => 'Test'} )
    assert dr.districts.keys.include?('TEST')
  end
end
