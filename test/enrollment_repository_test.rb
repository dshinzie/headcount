require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  #
  # def test_enrollment_repository_initializes_with_empty_hash
  #   er = EnrollmentRepository.new
  #
  #   assert_equal ({}), er.enrollments
  # end
  #
  #
  # def test_enrollment_hash_is_populated_after_loading
  #   er = EnrollmentRepository.new
  #   er.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv"
  #     }
  #   })
  #
  #   refute er.enrollments.nil?
  # end
  #
  # def test_enrollment_loads_enrollment_names_from_single_file
  #   er = EnrollmentRepository.new
  #   er.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv"
  #     }
  #   })
  #
  #   test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
  #   test_list.each { |enrollment| assert er.enrollments.keys.include?(enrollment.upcase)}
  # end
  #
  # def test_enrollment_loads_enrollment_instances_into_hash
  #   er = EnrollmentRepository.new
  #   er.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv"
  #     }
  #   })
  #
  #   assert er.enrollments.values.first.instance_of?(Enrollment)
  #   assert er.enrollments.values.last.instance_of?(Enrollment)
  # end
  #
  #
  # def test_find_by_name_returns_enrollment_instance
  #   dr = EnrollmentRepository.new
  #   dr.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv"
  #     }
  #   })
  #
  #   test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
  #   test_list.each { |enrollment| assert dr.find_by_name(enrollment.upcase).instance_of?(Enrollment) }
  # end
  #
  # def test_loads_high_school_file
  #   er = EnrollmentRepository.new
  #   er.load_data({
  #     :enrollment => {
  #       :high_school_graduation => "./data/High school graduation rates.csv"
  #       }
  #     })
  #
  #   refute er.enrollments.empty?
  # end

  def test_it_loads_two_files
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./fixture/Kindergartners in full-day program clean.csv",
        :high_school_graduation => "./fixture/High school graduation rates.csv"
        }
      })


    refute er.enrollments.kindergarten_participation.empty?
    #refute er.enrollments.high_school_graduation_participation.empty?
  end

end
