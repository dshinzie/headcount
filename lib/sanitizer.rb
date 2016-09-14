module Sanitizer

extend self
  def truncate(number)
    (number*1000).floor/1000.0
  end

end
