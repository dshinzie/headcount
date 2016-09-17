require_relative 'test_helper'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def test_can_create_new_district_name
    d = District.new({:name => "test"})

    assert_equal "TEST", d.name
  end
end
