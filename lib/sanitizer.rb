require 'pry'

module Sanitizer

extend self
  def truncate(number)
    (number*1000).floor/1000.0
  end

  def sanitize_hash(data_hash)
    data = {}
    data_hash.each do |key, value|
      data[key] = Sanitizer.truncate(value)
    end
    data
  end

  def sanitize_nested_hash(parent, data_hash, first_run)
    @nested = {} if first_run
    data_hash.each do |key, value|
      value.is_a?(Hash) ? sanitize_nested_hash(key, value, false)
      : data_hash[key] = Sanitizer.truncate(value)
    end
    @nested[parent] = data_hash unless parent.nil?
    @nested
  end

  def sanitize_symbols(input)
    return :pacific_islander if input.downcase.include?('pacific')
    return :native_american if input.downcase.include?('native')
    return :two_or_more if input.split.length > 1
    input.downcase.to_sym
  end

  def sanitize_years(input)
    input.include?('-') ? input.split('-').map(&:to_i) : input.to_i
  end


end
