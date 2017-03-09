require 'rubygems'

# Rails
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
require "action_controller/railtie"

require 'oj'

Oj.mimic_JSON()
begin
  require 'json'
rescue Exception
end

require 'benchmark/memory'

obj = {}
# obj = {some: "fake", data: 1}

Benchmark.memory do |x|
  x.report("to_json:"){ 10_000.times { obj.dup.to_json } }
  x.report("JSON:"){ 10_000.times { JSON.generate({}) } }
  x.report("JSON + as_json:"){ 10_000.times { JSON.generate(obj.dup.as_json) } } if obj.dup.respond_to?(:as_json)
  x.report("Oj:") { 10_000.times { Oj.dump({}) } }
  x.report("Oj + as_json:") { 10_000.times { Oj.dump(obj.dup.as_json) } } if obj.dup.respond_to?(:as_json)
  x.compare!
end

puts "---------------------------------------------\n\n"

require "benchmark"

Benchmark.benchmark(Benchmark::CAPTION, 14, Benchmark::FORMAT) do |x|
  x.report("to_json:"){ 10_000.times { obj.dup.to_json } }
  x.report("JSON:"){ 10_000.times { JSON.generate({}) } }
  x.report("JSON + as_json:"){ 10_000.times { JSON.generate(obj.dup.as_json) } } if obj.dup.respond_to?(:as_json)
  x.report("Oj:") { 10_000.times { Oj.dump({}) } }
  x.report("Oj + as_json:") { 10_000.times { Oj.dump(obj.dup.as_json) } } if obj.dup.respond_to?(:as_json)
end