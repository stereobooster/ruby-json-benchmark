require_relative './msg_pack_rails_compat'

def test_msgpack(test_data, test_result, implementation, implementation_compare)
  test_data.each do |key, val|
    test_result[key] ||= {}
    from_json = ActiveSupport::JSON.decode(test_result[key][implementation_compare])
    from_msgpack = begin
      res = MessagePack.pack(val)
      MessagePack.unpack(res)
    rescue StandardError => e
      e
    end
    test_result[key][implementation] = compare(from_json, from_msgpack)
  end
end
