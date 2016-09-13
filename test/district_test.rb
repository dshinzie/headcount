require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_district_name_is_instance_variable
    d = District.new({:location => "test"})

    assert_equal "TEST", d.name
  end


end
