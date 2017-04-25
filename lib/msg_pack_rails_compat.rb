require 'msgpack'

class Object
  def to_msgpack_rails(options = nil) #:nodoc:
    as_json(options).to_msgpack
  end
  def from_msgpack_rails(value) #:nodoc:
    MessagePack.unpack(value)
  end
end

# class Float
#   alias_method :to_msgpack_native, :to_msgpack

#   def to_msgpack(options = nil) #:nodoc:
#     if self.infinite?
#       nil.to_msgpack
#     else
#       to_msgpack_native
#     end
#   end
# end

MessagePack::DefaultFactory.register_type(0x01, Object, packer: :to_msgpack_rails, unpacker: :from_msgpack_rails)
