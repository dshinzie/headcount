require 'csv'

class Enrollment

  attr_reader :name

  attr_accessor :kindergarden_participation

  def initialize(input_hash)
    @name = input_hash[:location].upcase
    @kindergarden_participation = {}
  end

end
