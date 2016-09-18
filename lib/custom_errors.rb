
class UnknownDataError < StandardError
  def initialize(msg="Only use grades 3 or 8")
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
