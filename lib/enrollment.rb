require 'csv'

class Enrollment

  attr_reader :name

  attr_accessor :kindergarten_participation

  def initialize(input_hash)
    @name = input_hash[:name].upcase
    @kindergarten_participation = input_hash[:kindergarten_participation]
  end

end
