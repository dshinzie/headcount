require_relative 'test_helper'
require_relative '../lib/economic_profile'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/loader'

class EconomicProfileTest < Minitest::Test

  attr_reader :epr, :ep, :ep2, :ep3, :ep4

  def setup
    @epr = EconomicProfileRepository.new
    @epr.load_data({
      :economic_profile => {
        :median_household_income => "./fixture/Median household income.csv",
        :children_in_poverty => "./fixture/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./fixture/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./fixture/Title I students.csv"
      }
    })
    @ep = @epr.find_by_name("ACADEMY 20")
    @ep2 = @epr.find_by_name('ADAMS COUNTY 14')
    @ep3 = @epr.find_by_name('AGATE 300')
    @ep4 = @epr.find_by_name('COLORADO')
  end

  def test_can_get_average_income_in_year
    assert_equal 85060, ep.median_household_income_in_year(2005)
    assert_equal 41305.20, ep2.median_household_income_in_year(2009)
    assert_equal 61470.25, ep3.median_household_income_in_year(2008)
  end

  def test_can_get_household_income_average
    assert_equal 87635.40, ep.median_household_income_average
    assert_equal 41305.20, ep2.median_household_income_average
    assert_equal 59801.20, ep3.median_household_income_average
  end

  def test_can_get_poverty_in_year
    assert_equal 0.032, ep.children_in_poverty_in_year(1995)
    assert_equal 0.247, ep2.children_in_poverty_in_year(2007)
    assert_equal 0.264, ep2.children_in_poverty_in_year(2013)
  end

  def test_can_get_reduce_lunch_percentage
    assert_equal 0.27, ep4.free_or_reduced_price_lunch_percentage_in_year(2000)
    assert_equal 0.337, ep4.free_or_reduced_price_lunch_percentage_in_year(2006)
    assert_equal 0.3536, ep4.free_or_reduced_price_lunch_percentage_in_year(2008)
  end

  def test_can_get_reduce_lunch_total
    assert_equal 195149, ep4.free_or_reduced_price_lunch_number_in_year(2000)
    assert_equal 267590, ep4.free_or_reduced_price_lunch_number_in_year(2006)
    assert_equal 289404, ep4.free_or_reduced_price_lunch_number_in_year(2008)
  end

  def test_can_get_title_i
    assert_equal 0.014, ep.title_i_in_year(2009)
    assert_equal 0.71053, ep2.title_i_in_year(2012)
    assert_equal 0.5, ep3.title_i_in_year(2014)
    assert_equal 0.23178, ep4.title_i_in_year(2013)
  end

  def test_raises_error_if_invalid_input_median_income
    assert_raises(UnknownDataError) {ep.median_household_income_in_year(1884)}
    assert_raises(UnknownDataError) {ep.median_household_income_in_year(1987)}
    assert_raises(UnknownDataError) {ep.median_household_income_in_year(2052)}
  end

  def test_raises_error_if_invalid_input_children_in_poverty
    assert_raises(UnknownDataError) {ep.children_in_poverty_in_year(1884)}
    assert_raises(UnknownDataError) {ep.children_in_poverty_in_year(1990)}
    assert_raises(UnknownDataError) {ep.children_in_poverty_in_year(2064)}
  end

  def test_raises_error_if_invalid_input_reduced_free_lunch_percentage
    assert_raises(UnknownDataError) {ep4.free_or_reduced_price_lunch_percentage_in_year(1884)}
    assert_raises(UnknownDataError) {ep4.free_or_reduced_price_lunch_percentage_in_year(1990)}
    assert_raises(UnknownDataError) {ep4.free_or_reduced_price_lunch_percentage_in_year(2152)}
  end

  def test_raises_error_if_invalid_input_reduced_free_lunch_total
    assert_raises(UnknownDataError) {ep4.free_or_reduced_price_lunch_number_in_year(1884)}
    assert_raises(UnknownDataError) {ep4.free_or_reduced_price_lunch_number_in_year(1990)}
    assert_raises(UnknownDataError) {ep4.free_or_reduced_price_lunch_number_in_year(2152)}
  end

  def test_raises_error_if_invalid_input_title_i
    assert_raises(UnknownDataError) {ep4.title_i_in_year(1884)}
    assert_raises(UnknownDataError) {ep4.title_i_in_year(1990)}
    assert_raises(UnknownDataError) {ep4.title_i_in_year(2152)}
  end

end
