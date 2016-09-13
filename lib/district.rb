require 'csv'

class District

  attr_reader :name
  # attr_accessor :enrollment

  def initialize(name_hash)
    @name = name_hash[:location].upcase
    # @enrollment
    # @statewide_test
    # @economic_profile
  end

end
