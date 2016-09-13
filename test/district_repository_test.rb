require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

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

    expected = ['Colorado', 'ACADEMY 20', 'Agate 300']
    expected.each { |district| assert dr.districts.keys.include?(district.upcase)}
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

  def test_find_all_returns_all_closest_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    expected = ['COLORADO', 'COLORADO SPRINGS 11']
    assert_equal expected, dr.find_all_matching('Col')

  end



end
