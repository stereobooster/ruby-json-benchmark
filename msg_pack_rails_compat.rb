require "json/add/complex"
require "json/add/rational"

class Object
  def to_msgpack_rails(options = nil) #:nodoc:
    as_json(options).to_msgpack
  end
  def from_msgpack_rails(value) #:nodoc:
    MessagePack.unpack(value)
  end
end

# class Object
#   def as_json(options = nil) #:nodoc:
#     if respond_to?(:to_hash)
#       to_hash.as_json(options)
#     else
#       instance_values.as_json(options)
#     end
#   end
# end
MessagePack::DefaultFactory.register_type(0x01, Object, packer: :to_msgpack_rails, unpacker: :from_msgpack_rails)
