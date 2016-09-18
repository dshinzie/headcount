require_relative 'statewide_test'
require_relative 'loader'
require 'csv'
require 'pry'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @statewide_tests = {}
  end

  def load_data(file_hash)
    Loader.load_data_statewide(file_hash, @statewide_tests)
  end

  def find_by_name(name)
    @statewide_tests[name.upcase]
  end

end
