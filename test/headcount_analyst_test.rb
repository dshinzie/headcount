require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
      :enrollment => {
        :kindergarten => "./fixture/Kindergartners in full-day program.csv",
        :high_school_graduation => "./fixture/High school graduation rates.csv"
      },
      :economic_profile => {
        :median_household_income => "./fixture/Median household income.csv",
        :children_in_poverty => "./fixture/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./fixture/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./fixture/Title I students.csv"
          }
        })

  end

  # def test_enrollment_loads_with_district_repo_load
  #   refute dr.enrollment.nil?
  # end
  #
  # def test_enrollment_loads_enrollment_names
  #   test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
  #   test_list.each { |enrollment| assert dr.enrollment.enrollments.keys.include?(enrollment.upcase)}
  # end
  #
  # def test_it_finds_average_kindergarten_participation
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 0.530 , ha.find_average_participation("COLORADO", :kindergarten_participation)
  #   assert_equal 0.406 , ha.find_average_participation("ACADEMY 20", :kindergarten_participation)
  # end
  #
  # def test_it_finds_variation_btw_district_state
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 0.766 , ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  #   assert_equal 1.337 , ha.kindergarten_participation_rate_variation('ADAMS COUNTY 14', :against => 'COLORADO')
  # end
  #
  # def test_it_finds_variation_btw_two_districts
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 0.572 , ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
  # end
  #
  # def test_it_returns_a_float
  #   ha = HeadcountAnalyst.new(dr)
  #   result = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
  #
  #   assert result.instance_of?(Float)
  # end
  #
  # def test_it_rounds_to_three_decimal_places
  #   ha = HeadcountAnalyst.new(dr)
  #   result = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
  #   result = result.to_s.gsub!("0.", "")
  #
  #   assert_equal 3, result.length
  # end
  #
  # def test_rate_variation_trend_builds_hash
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   result = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  #
  #   refute result.empty?
  #   assert result[2007]
  # end
  #
  # def test_rate_variation_compares_all_years
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   result = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }
  #
  #   assert_equal result, ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  # end
  #
  # def test_it_finds_average_high_school_participation
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 0.751 , ha.find_average_participation("COLORADO", :high_school_graduation_participation)
  #   assert_equal 0.898 , ha.find_average_participation("ACADEMY 20", :high_school_graduation_participation)
  # end
  #
  # def test_it_finds_variation_btw_two_high_school_districts
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 1.467 , ha.high_school_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
  # end
  #
  # def test_kdg_participation_against_high_school
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  # end
  #
  # def test_kdg_correlation_to_hs_returns_true
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal true, ha.kindergarten_participation_correlates_with_high_school_graduation(for: "ACADEMY 20")
  # end
  #
  # def test_passing_in_statewide
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   refute  ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  # end
  #
  # def test_passing_in_array_of_districts
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal false, ha.kindergarten_participation_correlates_with_high_school_graduation(
  #   :across => ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14', 'AGATE 300'])
  #   assert ha.kindergarten_participation_correlates_with_high_school_graduation(
  #   :across => ['COLORADO', 'ACADEMY 20'])
  # end

  # def test_get_average_free_or_reduced_lunch_percentage
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 0.350, ha.get_average_lunch("COLORADO", :percentage)
  #   assert_equal 0.085, ha.get_average_lunch("ACADEMY 20", :percentage)
  #   assert_equal 0.742, ha.get_average_lunch("ADAMS COUNTY 14", :percentage)
  # end
  #
  # def test_get_average_free_or_reduced_lunch_total
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 40740.885, ha.get_average_lunch("COLORADO", :total)
  #   assert_equal 1884.466, ha.get_average_lunch("ACADEMY 20", :total)
  #   assert_equal 5241.2, ha.get_average_lunch("ADAMS COUNTY 14", :total)
  # end

  def test_returns_array_of_high_poverty_districts
    ha = HeadcountAnalyst.new(dr)

    ha.district_against_state_poverty_variation
  end


end
