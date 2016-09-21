require_relative 'sanitizer'
require_relative 'custom_errors'

class StatewideTest
  include Sanitizer

  attr_reader :name,
              :third_grade,
              :eighth_grade,
              :native_american,
              :asian,
              :black,
              :white,
              :pacific_islander,
              :hispanic,
              :two_or_more

  VALID_GRADES = [3,8]
  VALID_SUBJECTS = [:math, :reading, :writing]
  VALID_RACES = [:asian, :black, :pacific_islander, :hispanic,
                 :native_american, :two_or_more, :white]

  def initialize(input_hash)
    @name = input_hash[:name].upcase
    @third_grade = input_hash[:third_grade] || {}
    @eighth_grade = input_hash[:eighth_grade] || {}
    @native_american = input_hash[:native_american] || {}
    @asian = input_hash[:asian] || {}
    @black = input_hash[:black] || {}
    @white = input_hash[:white] || {}
    @pacific_islander = input_hash[:pacific_islander] || {}
    @hispanic = input_hash[:hispanic] || {}
    @two_or_more = input_hash[:two_or_more] || {}
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless VALID_GRADES.include?(grade)

    if grade == 3
      sanitize_nested_hash(nil, third_grade, true)
    else
      sanitize_nested_hash(nil, eighth_grade, true)
    end
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless VALID_RACES.include?(race)

    sanitize_nested_hash(nil, self.send(race), true)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless VALID_GRADES.include?(grade) &&
    VALID_SUBJECTS.include?(subject)

    result = truncate(self.third_grade[year][subject]) if grade == 3
    result = truncate(self.eighth_grade[year][subject]) if grade == 8

    return result == 0.0 ? 'N/A' : result
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless VALID_RACES.include?(race) &&
    VALID_SUBJECTS.include?(subject)

    result = truncate(self.send(race)[year][subject])

    return result == 0.0 ? 'N/A' : result
  end

end
