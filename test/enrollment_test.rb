require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_can_create_new_enrollment_name
    er = Enrollment.new({name: "test"})

    assert_equal "TEST", er.name
  end

  def test_can_create_new_enrollment_participation
    er = Enrollment.new({name: "test name",:kindergarten_participation => {test_header: "test"}})

    assert_equal ({test_header: "test"}), er.kindergarten_participation
  end

  def test_can_return_participation_hash_by_year
    test_hash = { 2011 => 0.911, 2012 => 0.654, 2014 => 0.5465, 2015 => 0.545}
    er = Enrollment.new({name: "test name",:kindergarten_participation => test_hash})

    assert_equal test_hash, er.kindergarten_participation_by_year
  end

  def test_can_return_participation_hash_in_year
    test_hash = { 2011 => 0.911, 2012 => 0.654, 2014 => 0.5465, 2015 => 0.545}
    er = Enrollment.new({name: "test name",:kindergarten_participation => test_hash})

    assert_equal 0.911, er.kindergarten_participation_in_year(2011)
    assert_equal 0.654, er.kindergarten_participation_in_year(2012)
    assert_equal 0.545, er.kindergarten_participation_in_year(2015)
  end

  def test_can_return_participation_hash_in_year
    test_hash = { 2011 => 0.911, 2012 => 0.654, 2014 => 0.5465, 2015 => 0.545}
    er = Enrollment.new({name: "test name",:kindergarten_participation => test_hash})

    assert_equal 0.911, er.kindergarten_participation_in_year(2011)
    assert_equal 0.654, er.kindergarten_participation_in_year(2012)
    assert_equal 0.545, er.kindergarten_participation_in_year(2015)
  end

  def test_can_returns_three_digit_float_participation
    test_hash = { 2011 => 0.91341, 2012 => 0.4, 2013 => 0.5465}
    er = Enrollment.new({name: "test name",:kindergarten_participation => test_hash})

    assert_equal 0.913, er.kindergarten_participation_in_year(2011)
    assert_equal 0.400, er.kindergarten_participation_in_year(2012)
    assert_equal 0.547, er.kindergarten_participation_in_year(2013)
  end

end
