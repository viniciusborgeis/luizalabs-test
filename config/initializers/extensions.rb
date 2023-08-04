class VirtualRecord
  attr_accessor :data

  def initialize(data)
    @data = symbolize_keys(data)
  end

  def [](key)
    data[key.to_sym]
  end

  def method_missing(method, *args, &block)
    if data.key?(method)
      data[method]
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    data.key?(method) || super
  end

  private

  def symbolize_keys(hash)
    hash.each_with_object({}) do |(key, value), new_hash|
      new_hash[key.to_sym] = value.is_a?(Hash) ? symbolize_keys(value) : value
    end
  end
end

# Extend the Hash class
class Hash
  def to_virtual_record
    VirtualRecord.new(self)
  end
end
