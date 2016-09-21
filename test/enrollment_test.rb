require_relative 'test_helper'
require_relative '../lib/enrollment'
require_relative '../lib/district_repository'
require_relative '../lib/economic_profile_repository'

class EnrollmentTest < Minitest::Test

  def test_it_returns_participation_by_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    result = { 2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal result, e.kindergarten_participation_by_year
  end

  def test_can_return_participation_hash_in_year
    test_hash = { 2011 => 0.911, 2012 => 0.654, 2014 => 0.5465, 2015 => 0.545}
    er = Enrollment.new({name: "test name",:kindergarten_participation => test_hash})

    assert_equal 0.911, er.kindergarten_participation_in_year(2011)
    assert_equal 0.654, er.kindergarten_participation_in_year(2012)
    assert_equal 0.545, er.kindergarten_participation_in_year(2015)
  end

  def test_it_returns_nil_if_year_does_not_exist
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal nil, e.kindergarten_participation_in_year(1990)
  end

  def test_can_create_new_enrollment_name
    er = Enrollment.new({name: "test"})

    assert_equal "TEST", er.name
  end

  def test_can_create_new_enrollment_participation_kindergarten
    er = Enrollment.new({name: "test name",:kindergarten_participation => {test_header: "test"}})

    assert_equal ({test_header: "test"}), er.kindergarten_participation
  end

  def test_can_returns_three_digit_float_participation
    test_hash = { 2011 => 0.91341, 2012 => 0.4, 2013 => 0.5465}
    er = Enrollment.new({name: "test name",:kindergarten_participation => test_hash})

    assert_equal 0.913, er.kindergarten_participation_in_year(2011)
    assert_equal 0.400, er.kindergarten_participation_in_year(2012)
    assert_equal 0.546, er.kindergarten_participation_in_year(2013)
  end

  def test_it_adds_enrollment_to_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    district = dr.find_by_name("GUNNISON WATERSHED RE1J")

    assert_in_delta 0.144, district.enrollment.kindergarten_participation_in_year(2004), 0.005
  end

  def test_can_create_new_enrollment_participation_high_school
    er = Enrollment.new({name: "test name",:kindergarten_participation => {test_header: "test"}})

    assert_equal ({test_header: "test"}), er.kindergarten_participation
    assert_equal ({}), er.high_school_graduation_participation
  end

  def test_high_school_graduation_participation_can_be_populated
    er = Enrollment.new({name: "test name",:high_school_graduation_participation => {test_header: "test value"}})

    expected = {:test_header => "test value"}

    assert_equal expected, er.high_school_graduation_participation
  end

  def test_can_return_hs_participation_hash_by_year
    test_hash = {2010=>0.724, 2011=>0.739, 2012=>0.753, 2013=>0.769, 2014=>0.773}
    er = Enrollment.new({name: "test name",:high_school_graduation_participation => test_hash})

    assert_equal test_hash, er.graduation_rate_by_year
  end

  def test_grad_rate_returns_participation_in_year
    test_hash = {2010=>0.724, 2011=>0.739, 2012=>0.753, 2013=>0.769, 2014=>0.773}
    e = Enrollment.new({:name => "ACADEMY 20", :high_school_graduation_participation => test_hash})

    assert_equal 0.724, e.graduation_rate_in_year(2010)
  end

  def test_grad_rate_returns_nil_if_year_does_not_exist
    e = Enrollment.new({:name => "ACADEMY 20", :high_school_graduation_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal nil, e.graduation_rate_in_year(1990)
  end

  def test_safe_year_retrieval_can_return_nil
    e = Enrollment.new({:name => "ACADEMY 20", :high_school_graduation_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert e.safe_year_retrieval(e.high_school_graduation_participation, 1990).nil?
  end

end
