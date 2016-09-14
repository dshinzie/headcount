require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
    @dr.load_all({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

  end

  def test_enrollment_loads_with_district_repo_load

    refute dr.enrollment.nil?
  end

  def test_enrollment_loads_enrollment_names_from_single_file

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |enrollment| assert dr.enrollment.enrollments.keys.include?(enrollment.upcase)}
  end

  def test_it_finds_average_participation

    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.530 , ha.find_average_participation("COLORADO")
    assert_equal 0.406 , ha.find_average_participation("ACADEMY 20")
  end

  def test_it_finds_variation_btw_district_state
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.766 , ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 1.337 , ha.kindergarten_participation_rate_variation('ADAMS COUNTY 14', :against => 'COLORADO')
  end

  def test_it_finds_variation_btw_two_districts
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.572 , ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
  end

  def test_it_returns_a_float
    ha = HeadcountAnalyst.new(dr)
    result = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')

    assert result.instance_of?(Float)
  end

  def test_it_rounds_to_three_decimal_places
    ha = HeadcountAnalyst.new(dr)
    result = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
    result = result.to_s.gsub!("0.", "")

    assert_equal 3, result.length
  end

  def test_ha_initializes_empty_rate_trend_hash
    ha = HeadcountAnalyst.new(dr)

    assert_equal ({}), ha.rate_trend
  end

  def test_rate_variation_trend_builds_hash
    ha = HeadcountAnalyst.new(dr)

    ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    refute ha.rate_trend.empty?
  end


  def test_first_run_builds_district_hash
    ha = HeadcountAnalyst.new(dr)

    result = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }

    assert_equal result, ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end
end
