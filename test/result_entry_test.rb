require_relative 'test_helper'
require_relative '../lib/result_entry'

class ResultEntryTest < Minitest::Test

  def test_free_and_reduced_price_lunch_rate_can_be_assigned
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5})

    assert_equal 0.5, r1.free_and_reduced_price_lunch_rate
  end

  def test_children_in_poverty_rate_can_be_assigned
    r1 = ResultEntry.new({children_in_poverty_rate: 0.25})

    assert_equal 0.25, r1.children_in_poverty_rate
  end

  def test_high_school_graduation_rate_can_be_assigned
    r1 = ResultEntry.new({high_school_graduation_rate: 0.75})

    assert_equal 0.75, r1.high_school_graduation_rate
  end

  def test_median_houshold_income_can_be_assigned
    r1 = ResultEntry.new({median_household_income: 50000})

    assert_equal 50000, r1.median_household_income
  end
  
end
