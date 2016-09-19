
class UnknownDataError < StandardError
  def initialize(msg="Invalid input.")
    super
  end
end

class UnknownRaceError < StandardError
  def initialize(msg="Please use a valid race.")
    super
  end
end

class MissingRaceDataError < StandardError
  def initialize(msg="Selected race has no data")
    super
  end
end
