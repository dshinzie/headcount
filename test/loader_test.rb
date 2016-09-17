require_relative 'test_helper'
require_relative '../lib/loader'

class LoaderTest < Minitest::Test

  def test_can_split_filenames_into_array
    file_hash = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
        }
      }
    Loader.extract_filenames(file_hash)

    assert Loader.extract_filenames(file_hash).instance_of?(Array)
  end

end
