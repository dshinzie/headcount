require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_parser'

class DistrictRepositoryTest < Minitest::Test

  def test_parser_grabs
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
  end

end
