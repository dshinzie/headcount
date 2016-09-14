require 'csv'

class District

  attr_reader :name
  # attr_accessor :enrollment

  def initialize(input_hash)
    @name = input_hash[:name].upcase
    # @enrollment
    # @statewide_test
    # @economic_profile
  end

end
