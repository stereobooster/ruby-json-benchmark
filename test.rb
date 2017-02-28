require 'rubygems'

# Rails
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
require "action_controller/railtie"

require 'oj'

require 'benchmark/memory'

Benchmark.memory do |x|
  x.report("to_json:"){ 10_000.times { {}.to_json } }
  x.report("JSON:"){ 10_000.times { JSON.generate({}) } }
  x.report("Oj:") { 10_000.times { Oj.dump({}) } }
  x.compare!
end

puts "---------------------------------------------\n\n"

require "benchmark"

Benchmark.benchmark(Benchmark::CAPTION, 7, Benchmark::FORMAT) do |x|
  x.report("to_json:"){ 10_000.times { {}.to_json } }
  x.report("JSON:"){ 10_000.times { JSON.generate({}) } }
  x.report("Oj:") { 10_000.times { Oj.dump({}) } }
end