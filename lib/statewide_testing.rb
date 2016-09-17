require 'csv'
require_relative 'sanitizer'

class StatewideTest

  attr_reader :name

  attr_accessor :third_grade, :eighth_grade, :math, :reading, :writing

  def initialize(input_hash)
    @name = input_hash[:name].upcase
    @third_grade = input_hash[:third_grade] || {}
    @eighth_grade = input_hash[:eighth_grade] || {}
    @math = input_hash[:math] || {}
    @reading = input_hash[:reading] || {}
    @writing = input_hash[:writing] || {}
  end
end
