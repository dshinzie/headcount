require_relative 'enrollment'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollment

  def initialize
    @enrollment = {}
    @participation = {}
  end

  def load_data(data_source)
    filename = data_source.values.reduce({}, :merge!).values.join
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|

      enrollment = Enrollment.new(row)
      row_data = create_participation_hash(row)
      #@participation[row_data.keys.join] = row_data.values.join.to_f.round(3)

      year = row_data.keys.join
      data = row_data.values.join.to_f
      @enrollment[enrollment.name] = enrollment
      @enrollment.find do |key, value|
        if enrollment.name == key
          @participation[year] = data
          enrollment.kindergarden_participation = @participation
        end
      end
    end
    @enrollment

  end

  def create_participation_hash(row)
    participation = {}
    participation[row[:timeframe]] = row[:data]
    return participation
  end

  def find_by_name(enrollment)
    @enrollment[enrollment]
  end

  def find_all_matching(search_criteria)
    matching_enrollment = @enrollment.keys.map do |enrollment|
      enrollment if enrollment.include?(search_criteria.upcase)
    end.compact
  end

end
