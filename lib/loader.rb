require "csv"

module Loader
extend self

  def extract_filenames(file_hash)
    filepaths = file_hash.values.map { |hash| hash.values}
    filepaths.flatten!
  end

  def csv_parse(filepath)
    CSV.open(filepath, headers: true, header_converters: :symbol)
  end

end
