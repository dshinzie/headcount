require_relative 'test_helper'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/statewide_test'
require_relative '../lib/loader'

class StatewideTestTest < Minitest::Test

  attr_reader :st, :str

  def setup
    @str = StatewideTestRepository.new
    @str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    @st = @str.find_by_name("ACADEMY 20")
  end

  def test_proficient_by_grade_returns_hash
    assert st.proficient_by_grade(3).instance_of?(Hash)
  end

  def test_proficient_by_grade_returns_third_grade_hash
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                 2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                 2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                 2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                 2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                 2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                 2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
               }
    assert_equal expected, st.proficient_by_grade(3)
  end

  def test_proficient_by_race_returns_hash_by_race
    expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
                 2012 => {math: 0.818, reading: 0.893, writing: 0.808},
                 2013 => {math: 0.805, reading: 0.901, writing: 0.810},
                 2014 => {math: 0.800, reading: 0.855, writing: 0.789},
               }

    assert_equal expected, st.proficient_by_race_or_ethnicity(:asian)
  end

  def test_proficient_for_subject_grade_year_returns_value_by_parameters
    assert_equal 0.857, st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    assert_equal 0.870, st.proficient_for_subject_by_grade_in_year(:reading, 3, 2012)
  end

  def test_proficient_for_subject_race_year_returns_value_by_parameters
    assert_equal 0.818, st.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end

  def test_proficient_by_grade_raises_error_if_grade_not_3_or_8
    assert_raises(UnknownDataError) {st.proficient_by_grade(4)}
    assert_raises(UnknownDataError) {st.proficient_by_grade(123)}
    assert_raises(UnknownDataError) {st.proficient_by_grade('a')}
  end

  def test_proficient_by_grade_raises_error_if_invalid_race
    assert_raises(UnknownRaceError) {st.proficient_by_race_or_ethnicity(:chicken)}
    assert_raises(UnknownRaceError) {st.proficient_by_race_or_ethnicity(:caucasian)}
    assert_raises(UnknownRaceError) {st.proficient_by_race_or_ethnicity(:spanish)}
  end

  def test_proficient_for_subject_grade_year_raises_error_if_wrong_parameter
    assert_raises(UnknownDataError) {st.proficient_for_subject_by_grade_in_year(:science, 3, 2012)}
    assert_raises(UnknownDataError) {st.proficient_for_subject_by_grade_in_year(:geometry, 8, 2941)}
    assert_raises(UnknownDataError) {st.proficient_for_subject_by_grade_in_year(:spanish, 12, 2012)}
  end

  def test_proficient_for_subject_race_year_raises_error_if_wrong_parameter
    assert_raises(UnknownDataError) {st.proficient_for_subject_by_race_in_year(:math, :yellow, 2012)}
    assert_raises(UnknownDataError) {st.proficient_for_subject_by_race_in_year(:geometry, :spanish, 2941)}
    assert_raises(UnknownDataError) {st.proficient_for_subject_by_race_in_year(:spanish, :white, 2012)}
  end

end
