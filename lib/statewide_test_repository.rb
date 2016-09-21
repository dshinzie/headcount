require_relative 'loader'

class StatewideTestRepository
  include Loader

  attr_reader :statewide_tests

  def initialize
    @statewide_tests = {}
  end

  def load_data(file_hash)
    load_data_statewide(file_hash, @statewide_tests)
  end

  def find_by_name(name)
    @statewide_tests[name.upcase]
  end

end
