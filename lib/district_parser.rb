require 'csv'
module DistrictParser

  def parse
    data = {}
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      district_name = line[:location].upcase
      create_hash_data(district_name, data, line)
    end
    data
  end

  # def create_hash_data(district_name, data, line)
  #   create_new_key_for_district(district_name, data)
  #   add_participation_data_by_year(district_name, data, line)
  # end

  # def csv_opener
  #   CSV.open(@path, headers: true, header_converters: :symbol)
  # end

end
