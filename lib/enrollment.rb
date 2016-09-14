require 'csv'
require 'pry'

class Enrollment

  attr_reader :name
  attr_accessor :kindergarten_participation

  def initialize(input_hash)
    @name = input_hash[:name].upcase
    @kindergarten_participation = input_hash[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation[year].round(3)
  end


end
