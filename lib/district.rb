require 'csv'

class District

  attr_reader :name
  attr_accessor :enrollment, :statewide_test

  def initialize(data_hash)
    @name = data_hash[:name].upcase
  end
end
