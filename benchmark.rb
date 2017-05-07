# encoding: utf-8

require 'json/add/complex'
require 'json/add/rational'
OJ_RAILS = { mode: :rails, use_to_json: true }.freeze

require './lib/test_data_json'
require './lib/test_data_rails'

require 'oj'
require './lib/msg_pack_rails_compat'

require 'benchmark/memory'
require 'benchmark/ips'

obj = TEST_DATA_JSON.merge(TEST_DATA_RAILS)
obj.delete(:'ActiveModel::Errors')
obj.delete(:'ActiveRecord::Relation')
obj.delete(:'ActiveRecord')
# obj.delete(:Complex)

Oj::Rails.optimize(Array, BigDecimal, Hash, Range, Regexp, Time, ActiveSupport::TimeWithZone)
Oj.add_to_json(Rational, Complex)

puts "\n"

Benchmark.memory do |x|
  x.report('Rails to_json') { 10_000.times { obj.to_json } }
  x.report('msgpack') { 10_000.times { MessagePack.pack(obj) } }
  x.report('Oj.dump') { 10_000.times { Oj.dump(obj, OJ_RAILS) } }
  x.report('Oj::Rails.encode') { 10_000.times { Oj::Rails.encode(obj) } }
  x.compare!
end

puts "---------------------------------------------\n\n"

Benchmark.ips do |x|
  x.report('Rails to_json') { obj.to_json }
  x.report('msgpack') { MessagePack.pack(obj) }
  x.report('Oj.dump') { Oj.dump(obj, OJ_RAILS) }
  x.report('Oj::Rails.encode') { Oj::Rails.encode(obj) }
  x.compare!
end

puts "\n"
