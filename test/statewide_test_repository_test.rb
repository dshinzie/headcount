require_relative 'test_helper'
require_relative '../lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_enrollment_repository_initializes_with_empty_hash
    str = StatewideTestRepository.new

    assert_equal ({}), str.statewide_tests
  end

  def test_it_loads_single_file
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./fixture/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"}
      })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |name| assert str.statewide_tests.keys.include?(name.upcase)}

  end

  def test_statwide_test_hash_is_populated_after_loading
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./fixture/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./fixture/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./fixture/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./fixture/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./fixture/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })

      refute str.statewide_tests.nil?
  end

  def test_statewide_tests_loads_statewide_test_instances_into_hash
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./fixture/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./fixture/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./fixture/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./fixture/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./fixture/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })

      assert str.statewide_tests.values.first.instance_of?(StatewideTest)
      assert str.statewide_tests.values.last.instance_of?(StatewideTest)
  end

  def test_it_loads_two_files
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./fixture/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./fixture/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv"}
      })

    st = str.find_by_name("COLORADO")

    assert st.third_grade
    assert st.white[2011][:math]
  end
end
