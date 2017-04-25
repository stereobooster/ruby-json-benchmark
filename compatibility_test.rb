# encoding: utf-8
require './lib/helper'
require './lib/test_data_json'

test_result = {}

test_to_json(TEST_DATA_JSON, test_result, :json_gem)
test_json_generate(TEST_DATA_JSON, test_result, :json_generate)

require './lib/test_data_rails'

test_to_json(TEST_DATA_JSON, test_result, :rails)
test_to_json(TEST_DATA_RAILS, test_result, :rails)

test_json_generate(TEST_DATA_RAILS, test_result, :json_generate)

require './lib/helper_msgpack'

test_msgpack(TEST_DATA_JSON, test_result, :msgpack, :rails)
test_msgpack(TEST_DATA_RAILS, test_result, :msgpack, :rails)

Oj::Rails.set_encoder()
Oj::Rails.set_decoder()
Oj::Rails.optimize(Array, BigDecimal, Hash, Range, Regexp, Time)
# DateTime doesn't work

test_to_json(TEST_DATA_JSON, test_result, :oj_to_json)
test_to_json(TEST_DATA_RAILS, test_result, :oj_to_json)

test_oj_dump(TEST_DATA_JSON, test_result, :oj_dump)
test_oj_dump(TEST_DATA_RAILS, test_result, :oj_dump)

test_oj_rails(TEST_DATA_JSON, test_result, :oj_rails)
test_oj_rails(TEST_DATA_RAILS, test_result, :oj_rails)

# NOTE:
#   JSON.generate in quirks mode equal to Obj.to_json from JSON gem
#   Oj.dump(val, mode: :rails) seems to be the same as Oj::Rails.encode(val)
rows = test_result.map do |key, val|
  [key,
    compare(val[:rails], val[:json_gem]),
    compare(val[:rails], val[:oj_dump]),
    compare(val[:rails], val[:oj_rails]),
    compare(val[:rails], val[:oj_to_json]),
    val[:msgpack]
  ]
end

require 'terminal-table'
puts "\nComparing Rails to_json with other JSON implementations\n"
puts Terminal::Table.new headings: ['class', 'JSON to_json', 'Oj.dump', 'Oj::Rails.encode', 'Oj to_json', 'msgpack "rails"'], rows: rows
