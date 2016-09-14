require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test


  def test_it_returns_participation_by_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    result = { 2010 => 0.392, 2011 => 0.354, 2012 => 0.268}
    assert_equal result, e.kindergarten_participation_by_year
  end

  def test_it_returns_participation_in_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.392, e.kindergarten_participation_in_year(2010)
  end

  def test_it_returns_nil_if_year_does_not_exist
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal nil, e.kindergarten_participation_in_year(1990)
  end

end
