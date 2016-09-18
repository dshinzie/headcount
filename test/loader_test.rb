require_relative 'test_helper'
require_relative '../lib/loader'

class LoaderTest < Minitest::Test

  def test_can_split_filenames_into_array
    file_hash = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
        }
      }
    Loader.extract_filenames(file_hash)

    assert Loader.extract_filenames(file_hash).instance_of?(Array)
  end

  def test_loader_adds_to_district_hash
    districts = {}
    Loader.add_district( {:location => 'Test'},  districts)
    assert districts.keys.include?('TEST')
  end

  def test_loader_runs_district_load
    file_hash = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    }
    districts = {}
    Loader.load_data_district(file_hash, districts)

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |district| assert districts.keys.include?(district.upcase)}
  end

  def test_loader_adds_to_enrollment_kindergarten_hash
    test_hash = {:location => 'Test', :timeframe => 2016, :data => 0.5}
    enrollments = {}
    Loader.add_enrollment(test_hash, 'kindergarten_participation', enrollments)

    assert enrollments.keys.include?('TEST')
    assert_equal ({ 2016 => 0.5 }), enrollments.values.reduce.kindergarten_participation
  end

  def test_loader_runs_enrollment_load
    file_hash = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    }
    enrollments = {}
    Loader.load_data_enrollment(file_hash, enrollments)

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |enrollment| assert enrollments.keys.include?(enrollment.upcase)}
  end
  # add enrollment specific test

  def test_loader_adds_to_statewide_tests_hash_by_third_grade_proficiency
    test_hash = {:location => 'Test', :score => 'Math', :timeframe => 2016, :data => 0.75}
    statewide_tests = {}
    Loader.add_testing_by_proficiency(test_hash, 'third_grade', statewide_tests)

    assert statewide_tests.keys.include?('TEST')
    assert_equal ({ 2016 => {:math => 0.75}}), statewide_tests.values.reduce.third_grade
  end

  def test_loader_adds_to_statewide_tests_hash_by_eighth_grade_grade_proficiency
    test_hash = {:location => 'Test', :score => 'Writing', :timeframe => 2016, :data => 0.90}
    statewide_tests = {}
    Loader.add_testing_by_proficiency(test_hash, 'eighth_grade', statewide_tests)

    assert statewide_tests.keys.include?('TEST')
    assert_equal ({ 2016 => {:writing => 0.90}}), statewide_tests.values.reduce.eighth_grade
  end

  def test_loader_adds_to_statewide_tests_hash_by_ethnicity_math
    test_hash = {:location => 'Test', :race_ethnicity => 'Native American', :timeframe => 2016, :data => 0.55}
    statewide_tests = {}
    Loader.add_testing_by_ethnicity(test_hash, :math, statewide_tests)

    assert statewide_tests.keys.include?('TEST')
    assert_equal ({2016 => {:math => 0.55}}), statewide_tests.values.reduce.native_american
  end

  def test_loader_adds_to_statewide_tests_hash_by_ethnicity_writing
    test_hash = {:location => 'Test', :race_ethnicity => 'White', :timeframe => 2016, :data => 0.66}
    statewide_tests = {}
    Loader.add_testing_by_ethnicity(test_hash, :writing, statewide_tests)

    assert statewide_tests.keys.include?('TEST')
    assert_equal ({2016 => {:writing => 0.66}}), statewide_tests.values.reduce.white
  end

  def test_loader_adds_to_statewide_tests_hash_by_ethnicity_reading
    test_hash = {:location => 'Test', :race_ethnicity => 'Asian', :timeframe => 2016, :data => 0.595}
    statewide_tests = {}
    Loader.add_testing_by_ethnicity(test_hash, :reading, statewide_tests)

    assert statewide_tests.keys.include?('TEST')
    assert_equal ({ 2016 => {:reading => 0.595}}), statewide_tests.values.reduce.asian
  end

  def test_loader_runs_statewide_test_load_individual_file
    file_hash = {
      :statewide_testing => {
        :writing => "./fixture/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    statewide_tests = {}
    Loader.load_data_statewide(file_hash, statewide_tests)

    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:writing] == 0.6569}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2012][:writing] == 0.3669}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.hispanic[2014][:writing] == 0.3762}
  end

  def test_loader_runs_statewide_test_load_multiple_files_of_ethnicity_category
    file_hash = {
      :statewide_testing => {
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    statewide_tests = {}
    Loader.load_data_statewide(file_hash, statewide_tests)

    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:math] == 0.7094}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2012][:math] == 0.3359}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.hispanic[2014][:math] == 0.3956}

    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:writing] == 0.6569}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2012][:writing] == 0.3669}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.hispanic[2014][:writing] == 0.3762}
  end

  def test_loader_runs_statewide_test_load_multiple_files_of_different_categories
    file_hash = {
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    statewide_tests = {}
    Loader.load_data_statewide(file_hash, statewide_tests)

    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.third_grade[2008][:math] == 0.697}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.third_grade[2009][:reading] == 0.726}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.third_grade[2010][:writing] == 0.504}

    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:writing] == 0.6569}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2012][:writing] == 0.3669}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.hispanic[2014][:writing] == 0.3762}
  end

  def test_loader_runs_statewide_test_load
    file_hash = {
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    statewide_tests = {}
    Loader.load_data_statewide(file_hash, statewide_tests)

    test_names = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_names.each { |statewide_test| assert statewide_tests.keys.include?(statewide_test.upcase)}

    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.third_grade[2008][:math] == 0.697}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.eighth_grade[2010][:reading] == 0.679}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.white[2011][:math] == 0.6585}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2014][:reading] == 0.5165}
    assert statewide_tests.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:writing] == 0.6569}
  end

end
