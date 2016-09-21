require_relative 'test_helper'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def test_can_create_new_district_name
    d = District.new({:name => "test"})

    assert_equal "TEST", d.name
  end

  def test_can_create_new_enrollment
    d = District.new({:name => "test"})
    d.enrollment = {:enrollment => "test_2"}

    assert_equal ({:enrollment => "test_2"}), d.enrollment
  end

  def test_can_create_new_statewide_test
    d = District.new({:name => "test"})
    d.statewide_test = {:statewide_test => "test_3"}

    assert_equal ({:statewide_test => "test_3"}), d.statewide_test
  end

  def test_can_create_new_economic_profile
    d = District.new({:name => "test"})
    d.economic_profile = {:economic_profile => "test_4"}

    assert_equal ({:economic_profile => "test_4"}), d.economic_profile
  end
  
end
