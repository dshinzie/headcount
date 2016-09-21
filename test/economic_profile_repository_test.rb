require_relative 'test_helper'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/loader'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_economic_profile_initializes_with_empty_hash
    epr = EconomicProfileRepository.new

    assert_equal ({}), epr.economic_profiles
  end

  def test_creates_new_economic_profile
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./fixture/Median household income.csv",
        :children_in_poverty => "./fixture/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./fixture/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./fixture/Title I students.csv"
      }
    })

    assert epr.instance_of?(EconomicProfileRepository)
  end

end
