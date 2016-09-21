require_relative 'test_helper'
require_relative '../lib/sanitizer'

class SanitizerTest < Minitest::Test

  def test_can_truncate_values
    assert_equal 0.709, Sanitizer.truncate(0.7094)
    assert_equal 0.545, Sanitizer.truncate(0.54541345)
    assert_equal 0.100, Sanitizer.truncate(0.10014)
  end

  def test_can_sanitize_hash
    test_hash = {:math=>0.7094, :reading=>0.7482, :writing=>0.6569}
    expected = {:math=>0.709, :reading=>0.748, :writing=>0.656}

    assert_equal expected, Sanitizer.sanitize_hash(test_hash)
  end

  def test_can_sanitize_to_symbols
    assert_equal :pacific_islander, Sanitizer.sanitize_symbols('Hawaiian/Pacific Islander')
    assert_equal :two_or_more, Sanitizer.sanitize_symbols('All Students')
    assert_equal :native_american, Sanitizer.sanitize_symbols('Native American')
    assert_equal :two_or_more, Sanitizer.sanitize_symbols('Two or More')
  end

  def test_can_sanitize_nested_hash
    test_hash = {2011=>{:math=>0.7094, :reading=>0.7482, :writing=>0.6569},
                 2012=>{:math=>0.7192, :reading=>0.7574, :writing=>0.6588}}
    expected = {2011=>{:math=>0.709, :reading=>0.748, :writing=>0.656},
                2012=>{:math=>0.719, :reading=>0.757, :writing=>0.658}}

    assert_equal expected, Sanitizer.sanitize_nested_hash(nil, test_hash, true)
  end

  def test_can_sanitize_nested_hashes_extreme
    test_hash = {2011=>{:math=>0.7094, :reading=>0.7482, :writing=>0.6569},
                 2012=>{:math=>0.7192, :reading=>0.7574, :writing=>0.6588},
                 2013=>{:math=>0.7323, :reading=>0.7692, :writing=>0.6821},
                 2014=>{:math=>0.7341, :reading=>0.7697, :writing=>0.6846}}
    expected_hash = {2011=>{:math=>0.709, :reading=>0.748, :writing=>0.656},
                     2012=>{:math=>0.719, :reading=>0.757, :writing=>0.658},
                     2013=>{:math=>0.732, :reading=>0.769, :writing=>0.682},
                     2014=>{:math=>0.734, :reading=>0.769, :writing=>0.684}}

    assert_equal expected_hash, Sanitizer.sanitize_nested_hash(nil, test_hash, true)
  end

  def test_can_sanitize_years
    assert_equal 2009, Sanitizer.sanitize_years('2009')
    assert_equal 1990, Sanitizer.sanitize_years('1990')
    assert_equal [2005, 2009], Sanitizer.sanitize_years('2005-2009')
    assert_equal [2000, 3000], Sanitizer.sanitize_years('2000-3000')
  end

end
