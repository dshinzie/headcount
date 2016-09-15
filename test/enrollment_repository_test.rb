require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_enrollment_repository_initializes_with_empty_hash
    er = EnrollmentRepository.new

    assert_equal ({}), er.enrollments
  end


  def test_enrollment_hash_is_populated_after_loading
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    refute er.enrollments.nil?
  end

  def test_enrollment_loads_enrollment_names_from_single_file
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |enrollment| assert er.enrollments.keys.include?(enrollment.upcase)}
  end

  def test_enrollment_loads_enrollment_instances_into_hash
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    assert er.enrollments.values.first.instance_of?(Enrollment)
    assert er.enrollments.values.last.instance_of?(Enrollment)
  end


  def test_find_by_name_returns_enrollment_instance
    dr = EnrollmentRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |enrollment| assert dr.find_by_name(enrollment.upcase).instance_of?(Enrollment) }
  end

  def test_loads_high_school_file
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :high_school_graduation => "./data/High school graduation rates.csv"
        }
      })

    refute er.enrollments.empty?
  end

  def test_it_loads_two_files
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./fixture/Kindergartners in full-day program clean.csv",
        :high_school_graduation => "./fixture/High school graduation rates.csv"
        }
      })

    e = er.find_by_name("COLORADO")

    assert e.kindergarten_participation
    assert e.high_school_graduation_participation
  end

  def test_it_loads_correct_data_for_two_files
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./fixture/Kindergartners in full-day program clean.csv",
        :high_school_graduation => "./fixture/High school graduation rates.csv"
        }
      })

    e = er.find_by_name("COLORADO")

    kindergarten_data = {2007=> 0.39465, 2006=> 0.33677, 2005=>0.27807, 2004=>0.24014, 2008=>0.5357, 2009=>0.598, 2010=>0.64019, 2011=>0.672, 2012=>0.695, 2013=>0.70263, 2014=>0.74118}

    high_school_data = {2010=>0.724, 2011=>0.739, 2012=>0.75354, 2013=>0.769, 2014=>0.773}

    assert_equal kindergarten_data, e.kindergarten_participation
    assert_equal high_school_data,  e.high_school_graduation_participation
  end

end
