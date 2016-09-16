require 'csv'
require_relative 'sanitizer'

class Enrollment

  attr_reader :name

  attr_accessor :kindergarten_participation, :high_school_graduation_participation

  def initialize(input_hash)
    @name = input_hash[:name].upcase
    @kindergarten_participation = input_hash[:kindergarten_participation] || {}
    @high_school_graduation_participation = input_hash[:high_school_graduation_participation] || {}
  end

  def kindergarten_participation_by_year
    sanitize_hash(@kindergarten_participation)
  end

  def graduation_rate_by_year
    sanitize_hash(@high_school_graduation_participation)
  end

  def sanitize_hash(data_hash)
    data = {}
    data_hash.each do |key, value|
      data[key] = Sanitizer.truncate(value)
    end
    data
  end

  def kindergarten_participation_in_year(year)
    safe_year_retrieval(@kindergarten_participation, year)
  end

  def graduation_rate_in_year(year)
    safe_year_retrieval(@high_school_graduation_participation, year)
  end

  def safe_year_retrieval(data_hash, year)
    unless data_hash.has_key?(year)
      return nil
    else
      Sanitizer.truncate(data_hash[year])
    end
  end

end
