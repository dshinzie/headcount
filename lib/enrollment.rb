require 'csv'
require_relative 'sanitizer'

class Enrollment

  attr_reader :name

  attr_accessor :kindergarten_participation

  def initialize(input_hash)
    @name = input_hash[:name].upcase
    @kindergarten_participation = input_hash[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    data = {}
    @kindergarten_participation.each do |key, value|
      data[key] = Sanitizer.truncate(value)
    end
    data
  end

  def kindergarten_participation_in_year(year)
    unless @kindergarten_participation.has_key?(year)
      return nil
    else
      Sanitizer.truncate(@kindergarten_participation[year])
    end
  end

end
