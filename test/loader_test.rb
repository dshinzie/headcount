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
    Loader.add_district( {:location => 'Test'}, districts = {} )
    assert Loader.d.keys.include?('TEST')
  end

  def test_loader_runs_district_load
    file_hash = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    }
    Loader.load_data_district(file_hash, districts = {})

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |district| assert Loader.d.keys.include?(district.upcase)}
  end

  def test_loader_adds_to_enrollment_kindergarten_hash
    test_hash = {:location => 'Test', :timeframe => 2016, :data => 0.5}
    Loader.add_enrollment(test_hash, 'kindergarten_participation', enrollments = {})

    assert Loader.e.keys.include?('TEST')
    assert_equal ({ 2016 => 0.5 }), Loader.e.values.reduce.kindergarten_participation
  end

  def test_loader_runs_enrollment_load
    file_hash = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    }
    Loader.load_data_enrollment(file_hash, enrollments = {})

    test_list = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_list.each { |enrollment| assert Loader.e.keys.include?(enrollment.upcase)}
  end
  # add enrollment specific test

  def test_loader_adds_to_statewide_tests_hash_by_third_grade_proficiency
    test_hash = {:location => 'Test', :score => 'Math', :timeframe => 2016, :data => 0.75}
    Loader.add_testing_by_proficiency(test_hash, 'third_grade', statewide_tests = {})

    assert Loader.st.keys.include?('TEST')
    assert_equal ({ 2016 => {:math => 0.75}}), Loader.st.values.reduce.third_grade
  end

  def test_loader_adds_to_statewide_tests_hash_by_eighth_grade_grade_proficiency
    test_hash = {:location => 'Test', :score => 'Writing', :timeframe => 2016, :data => 0.90}
    Loader.add_testing_by_proficiency(test_hash, 'eighth_grade', statewide_tests = {})

    assert Loader.st.keys.include?('TEST')
    assert_equal ({ 2016 => {:writing => 0.90}}), Loader.st.values.reduce.eighth_grade
  end

  def test_loader_adds_to_statewide_tests_hash_by_ethnicity_math
    test_hash = {:location => 'Test', :race_ethnicity => 'Native American', :timeframe => 2016, :data => 0.55}
    Loader.add_testing_by_ethnicity(test_hash, :math, statewide_tests = {})

    assert Loader.st.keys.include?('TEST')
    assert_equal ({2016 => {:math => 0.55}}), Loader.st.values.reduce.native_american
  end

  def test_loader_adds_to_statewide_tests_hash_by_ethnicity_writing
    test_hash = {:location => 'Test', :race_ethnicity => 'White', :timeframe => 2016, :data => 0.66}
    Loader.add_testing_by_ethnicity(test_hash, :writing, statewide_tests = {})

    assert Loader.st.keys.include?('TEST')
    assert_equal ({2016 => {:writing => 0.66}}), Loader.st.values.reduce.white
  end

  def test_loader_adds_to_statewide_tests_hash_by_ethnicity_reading
    test_hash = {:location => 'Test', :race_ethnicity => 'Asian', :timeframe => 2016, :data => 0.595}
    Loader.add_testing_by_ethnicity(test_hash, :reading, statewide_tests = {})

    assert Loader.st.keys.include?('TEST')
    assert_equal ({ 2016 => {:reading => 0.595}}), Loader.st.values.reduce.asian
  end

  def test_loader_runs_statewide_test_load_individual_file
    file_hash = {
      :statewide_testing => {
        :writing => "./fixture/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    Loader.load_data_statewide(file_hash, statewide_tests = {})

    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:writing] == 0.6569}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2012][:writing] == 0.3669}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.hispanic[2014][:writing] == 0.3762}
  end

  def test_loader_runs_statewide_test_load_multiple_files_of_ethnicity_category
    file_hash = {
      :statewide_testing => {
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    Loader.load_data_statewide(file_hash, statewide_tests = {})

    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:math] == 0.7094}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2012][:math] == 0.3359}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.hispanic[2014][:math] == 0.3956}

    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:writing] == 0.6569}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2012][:writing] == 0.3669}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.hispanic[2014][:writing] == 0.3762}
  end

  def test_loader_runs_statewide_test_load_multiple_files_of_different_categories
    file_hash = {
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    Loader.load_data_statewide(file_hash, statewide_tests = {})

    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.third_grade[2008][:math] == 0.697}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.third_grade[2009][:reading] == 0.726}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.third_grade[2010][:writing] == 0.504}

    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:writing] == 0.6569}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2012][:writing] == 0.3669}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.hispanic[2014][:writing] == 0.3762}
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
    Loader.load_data_statewide(file_hash, statewide_tests = {})

    test_names = ['Colorado', 'ACADEMY 20', 'Agate 300']
    test_names.each { |statewide_test| assert Loader.st.keys.include?(statewide_test.upcase)}

    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.third_grade[2008][:math] == 0.697}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.eighth_grade[2010][:reading] == 0.679}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.white[2011][:math] == 0.6585}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.black[2014][:reading] == 0.5165}
    assert Loader.st.values.find{|e| e.name.upcase == 'COLORADO' && e.asian[2011][:writing] == 0.6569}
  end

  def test_loader_adds_to_median_income_hash
    test_hash = {:location => 'Test', :timeframe => '2005-2009', :dataformat => 'Currency', :data => 56222}
    Loader.add_income_poverty_title(test_hash, :median_household_income, economic_profiles = {})

    assert Loader.ep.values.find{|e| e.name.upcase == 'TEST' && e.median_household_income[[2005, 2009]] == 56222}
  end

  def test_loader_adds_to_median_income_hash_from_file
    file_hash = {
      :economic_profile => {
        :median_household_income => "./fixture/Median household income.csv"
      }
    }
    Loader.load_data_economic(file_hash, economic_profiles = {})

    assert Loader.ep.values.find{|e| e.name.upcase == 'COLORADO' && e.median_household_income[[2005, 2009]] == 56222}
    assert Loader.ep.values.find{|e| e.name.upcase == 'ACADEMY 20' && e.median_household_income[[2006, 2010]] == 85450}
    assert Loader.ep.values.find{|e| e.name.upcase == 'AGATE 300' && e.median_household_income[[2009, 2013]] == 53125}
  end

  def test_loader_adds_to_children_in_poverty_hash
    test_hash = {:location => 'Test', :timeframe => '2005', :dataformat => 'Percet', :data => 0.032}
    Loader.add_income_poverty_title(test_hash, :children_in_poverty, economic_profiles = {})

    assert Loader.ep.values.find{|e| e.name.upcase == 'TEST' && e.children_in_poverty[2005] == 0.032}
  end

  def test_loader_adds_to_children_in_poverty_hash_from_file
    file_hash = {
      :economic_profile => {
        :children_in_poverty => "./fixture/School-aged children in poverty.csv"
      }
    }
    Loader.load_data_economic(file_hash, economic_profiles = {})

    assert Loader.ep.values.find{|e| e.name.upcase == 'ACADEMY 20' && e.children_in_poverty[2005] == 0.042}
    assert Loader.ep.values.find{|e| e.name.upcase == 'ACADEMY 20' && e.children_in_poverty[2013] == 0.048}
    assert Loader.ep.values.find{|e| e.name.upcase == 'ADAMS COUNTY 14' && e.children_in_poverty[2010] == 0.23185}
  end

  def test_loader_adds_to_title_hash
    test_hash = {:location => 'Test', :timeframe => '2009', :dataformat => 'Percent', :data => 0.216}
    Loader.add_income_poverty_title(test_hash, :title_i, economic_profiles = {})

    assert Loader.ep.values.find{|e| e.name.upcase == 'TEST' && e.title_i[2009] == 0.216}
  end

  def test_loader_adds_to_title_hash_from_file
    file_hash = {
      :economic_profile => {
        :title_i => "./fixture/Title I students.csv"
      }
    }
    Loader.load_data_economic(file_hash, economic_profiles = {})

    assert Loader.ep.values.find{|e| e.name.upcase == 'COLORADO' && e.title_i[2009] == 0.216}
    assert Loader.ep.values.find{|e| e.name.upcase == 'ACADEMY 20' && e.title_i[2013] == 0.01246}
    assert Loader.ep.values.find{|e| e.name.upcase == 'ADAMS COUNTY 14' && e.title_i[2014] == 0.66126}
  end

  def test_loader_adds_to_reduced_lunch_hash_for_percent
    test_hash = {:location => 'Test', :poverty_level => 'Eligible for Free or Reduced Lunch',:timeframe => '2009', :dataformat => 'Percent', :data => 0.07}
    Loader.add_reduced_price_lunch(test_hash, :free_or_reduced_price_lunch, economic_profiles = {})

    assert Loader.ep.values.find{|e| e.name.upcase == 'TEST' && e.free_or_reduced_price_lunch[2009][:percentage] == 0.07}
  end

  def test_loader_adds_to_reduced_lunch_hash_for_total
    test_hash = {:location => 'Test', :poverty_level => 'Eligible for Free or Reduced Lunch', :timeframe => '2009', :dataformat => 'Number', :data => 1234}
    Loader.add_reduced_price_lunch(test_hash, :free_or_reduced_price_lunch, economic_profiles = {})

    assert Loader.ep.values.find{|e| e.name.upcase == 'TEST' && e.free_or_reduced_price_lunch[2009][:total] == 1234}
  end

  def test_loader_adds_to_reduced_lunch_hash_only_both_free_or_reduced
    test_hash2 = {:location => 'Test', :poverty_level => 'Eligible for Free', :timeframe => '2009', :dataformat => 'Number', :data => 1234}
    Loader.add_reduced_price_lunch(test_hash2, :free_or_reduced_price_lunch, economic_profiles = {})

    refute Loader.ep.values.find{|e| e.name.upcase == 'TEST'}
  end

  def test_loader_adds_to_reduced_lunch_hash_from_file
    file_hash = {
        :economic_profile => {
          :free_or_reduced_price_lunch => "./fixture/Students qualifying for free or reduced price lunch.csv"
        }
      }
    Loader.load_data_economic(file_hash, economic_profiles = {})

    assert Loader.ep.values.find{|e| e.name.upcase == 'COLORADO' && e.free_or_reduced_price_lunch[2000] == {:percentage => 0.27, :total => 195149}}
    assert Loader.ep.values.find{|e| e.name.upcase == 'COLORADO' && e.free_or_reduced_price_lunch[2003] == {:percentage => 0.30, :total => 228710}}
    assert Loader.ep.values.find{|e| e.name.upcase == 'COLORADO' && e.free_or_reduced_price_lunch[2014] == {:percentage => 0.41593, :total => 369760}}
  end

end
