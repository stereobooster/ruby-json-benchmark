# encoding: utf-8

require 'rails/all'
require 'oj'

require 'benchmark'
begin
  require 'benchmark/memory'
rescue LoadError => e
end

# super compatible mode
Oj.default_options = { mode: :compat, use_as_json: true, float_precision: 16, bigdecimal_as_decimal: false, nan: :null, escape_mode: :xss_safe }

Oj.mimic_JSON()
begin
  require 'json'
rescue Exception
end

obj = {some: 'fake', data: 1}

if Benchmark.respond_to?(:memory)
  Benchmark.memory do |x|
    x.report('to_json:'){ 10_000.times { obj.dup.to_json } }
    x.report('JSON:'){ 10_000.times { JSON.generate(obj.dup) } }
    x.report('Oj:') { 10_000.times { Oj.dump(obj.dup) } }
    x.compare!
  end
  puts "\n---------------------------------------------\n\n"
end

Benchmark.benchmark(Benchmark::CAPTION, 14, Benchmark::FORMAT) do |x|
  x.report('to_json:'){ 10_000.times { obj.dup.to_json } }
  x.report('JSON:'){ 10_000.times { JSON.generate(obj.dup) } }
  x.report('Oj:') { 10_000.times { Oj.dump(obj.dup) } }
end
