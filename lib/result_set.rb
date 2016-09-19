require "pry"

class ResultSet
  attr_reader :matching_districts, :statewide_average

  def initialize(input_hash)
    @matching_districts = input_hash[:matching_districts]
    @statewide_average = input_hash[:statewide_average]
  end




end
