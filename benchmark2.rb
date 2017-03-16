require './test_data'
require 'benchmark'
begin
  require 'benchmark/memory'
rescue LoadError => e
end

obj = TEST_DATA.dup
obj.delete(:'ActiveModel::Errors')
obj.delete(:'ActiveRecord::Relation')
obj.delete(:Complex)

puts "\n"

if Benchmark.respond_to?(:memory)
  Benchmark.memory do |x|
    x.report('to_json:'){ 10_000.times { obj.to_json } }
    Oj.default_options = OJ_1
    x.report('Oj.dump o') { 10_000.times { Oj.dump(obj) } }
    Oj.default_options = OJ_2
    x.report('Oj.dump c') { 10_000.times { Oj.dump(obj) } }
    Oj.default_options = OJ_3
    x.report('Oj.dump c, aj') { 10_000.times { Oj.dump(obj) } }
    x.compare!
  end
  puts "---------------------------------------------\n\n"
end

Benchmark.benchmark(Benchmark::CAPTION, 14, Benchmark::FORMAT) do |x|
  x.report('to_json:'){ 10_000.times { obj.to_json } }
  Oj.default_options = OJ_1
  x.report('Oj.dump o') { 10_000.times { Oj.dump(obj) } }
  Oj.default_options = OJ_2
  x.report('Oj.dump c') { 10_000.times { Oj.dump(obj) } }
  Oj.default_options = OJ_3
  x.report('Oj.dump c, aj') { 10_000.times { Oj.dump(obj) } }
end

puts "\n"
