# encoding: utf-8
require 'benchmark/memory'
require 'benchmark/ips'

require 'json/add/complex'
require 'json/add/rational'

require './lib/test_data_json'
require './lib/test_data_rails'

obj = TEST_DATA_JSON.merge(TEST_DATA_RAILS)
obj.delete(:'ActiveModel::Errors')
obj.delete(:'ActiveRecord::Relation')
obj.delete(:'ActiveRecord')
# obj.delete(:Complex)

puts "Rails"

Benchmark.memory do |x|
  x.report('to_json') { 10_000.times { obj.to_json } }
end

puts "---------------------------------------------\n\n"

Benchmark.ips do |x|
  x.report('to_json') { obj.to_json }
end

puts "\n with Oj"

require 'oj'
Oj.optimize_rails()
Oj.add_to_json(Rational, Complex)

Benchmark.memory do |x|
  x.report('to_json') { 10_000.times { obj.to_json } }
end

puts "---------------------------------------------\n\n"

Benchmark.ips do |x|
  x.report('to_json') { obj.to_json }
end
