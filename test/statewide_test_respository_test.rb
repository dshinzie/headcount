require_relative 'test_helper'
require_relative '../lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_enrollment_repository_initializes_with_empty_hash
    str = StatewideTestRepository.new

    assert_equal ({}), str.statewide_tests
  end

  def test_enrollment_hash_is_populated_after_loading
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./fixture/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })

      refute str.statewide_tests.nil?
  end
end
