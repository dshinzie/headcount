require_relative 'test_helper'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/loader'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_economic_profile_initializes_with_empty_hash
    epr = EconomicProfileRepository.new

    assert_equal ({}), epr.economic_profiles
  end

  def test_creates_new_economic_profile
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./fixture/Median household income.csv",
        :children_in_poverty => "./fixture/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./fixture/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./fixture/Title I students.csv"
      }
    })

    assert epr.instance_of?(EconomicProfileRepository)
  end

  def test_econommic_profile_hash_is_populated_after_loading
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./fixture/Median household income.csv",
        :children_in_poverty => "./fixture/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./fixture/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./fixture/Title I students.csv"
      }
    })

    refute epr.economic_profiles.nil?
  end

  def test_economic_profile_repo_loads_from_single_file
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./fixture/Median household income.csv",
        :children_in_poverty => "./fixture/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./fixture/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./fixture/Title I students.csv"
      }
    })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |district| assert epr.economic_profiles.keys.include?(district.upcase)}
  end

  def test_find_by_name_returns_district_instance
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./fixture/Median household income.csv",
        :children_in_poverty => "./fixture/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./fixture/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./fixture/Title I students.csv"
      }
    })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |district| assert epr.find_by_name(district.upcase).instance_of?(EconomicProfile) }
  end

end
