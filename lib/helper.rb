require 'oj'
require 'json'

# this required for msgpack compatibility test
require 'json/add/complex'
require 'json/add/rational'

def compare(expected, result)
  if result.is_a? Exception
    '💀'
  else
    expected == result ? '👌' : '❌'
  end
end

# def compare(expected, result)
#   if result.is_a? Exception
#     'Error'
#   else
#     expected == result ? 'Ok' : 'Fail'
#   end
# end

def test_to_json(test_data, test_result, implementation)
  test_data.each do |key, val|
    test_result[key] ||= {}
    test_result[key][implementation] = begin
      val.to_json
    rescue JSON::GeneratorError => e
      e
    end
  end
end

def test_json_generate(test_data, test_result, implementation)
  test_data.each do |key, val|
    test_result[key] ||= {}
    test_result[key][implementation] = begin
      JSON.generate(val, quirks_mode: true)
    rescue JSON::GeneratorError => e
      e
    end
  end
end

OJ_RAILS = {mode: :rails, use_to_json: true}.freeze
def test_oj_dump(test_data, test_result, implementation)
  test_data.each do |key, val|
    test_result[key] ||= {}
    test_result[key][implementation] = begin
      Oj.dump(val, OJ_RAILS)
    rescue NoMemoryError => e
      e
    rescue NotImplementedError => e
      e
    rescue EncodingError => e
      e
    rescue RuntimeError => e
      e
    end
  end
end

def test_oj_rails(test_data, test_result, implementation)
  test_data.each do |key, val|
    test_result[key] ||= {}
    test_result[key][implementation] = begin
      Oj::Rails.encode(val)
    rescue NoMemoryError => e
      e
    rescue NotImplementedError => e
      e
    rescue EncodingError => e
      e
    rescue RuntimeError => e
      e
    end
  end
end
