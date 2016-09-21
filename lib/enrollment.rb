require_relative 'sanitizer'

class Enrollment
  include Sanitizer

  attr_reader :name

  attr_accessor :kindergarten_participation,
                :high_school_graduation_participation

  def initialize(input_hash)
    @name = input_hash[:name].upcase
    @kindergarten_participation = input_hash[:kindergarten_participation] || {}
    @high_school_graduation_participation =
    input_hash[:high_school_graduation_participation] || {}
  end

  def kindergarten_participation_by_year
    sanitize_hash(@kindergarten_participation)
  end

  def graduation_rate_by_year
    sanitize_hash(@high_school_graduation_participation)
  end

  def kindergarten_participation_in_year(year)
    safe_year_retrieval(@kindergarten_participation, year)
  end

  def graduation_rate_in_year(year)
    safe_year_retrieval(@high_school_graduation_participation, year)
  end

  def safe_year_retrieval(data_hash, year)
    return nil if !data_hash[year]
    truncate(data_hash[year])
  end

end
