class EconomicProfileRepository

  attr_reader :economic_profiles

  def initialize
    @economic_profiles = {}
  end

  def load_data(file_hash)
    Loader.load_data_economic(file_hash, @economic_profiles)
  end

  def find_by_name(name)
    @economic_profiles[name.upcase]
  end

end
