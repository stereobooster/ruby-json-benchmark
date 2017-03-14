require 'rubygems'
require 'oj'

# super compatible mode
OJ_3 = { mode: :compat, use_as_json: true, float_precision: 16, bigdecimal_as_decimal: false }
Oj.default_options = OJ_3

# Rails
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
require 'action_controller/railtie'
require 'active_model'
require 'active_record'

# test data
class Colors
  include Enumerable
  def each
    yield 'red'
    yield 'green'
    yield 'blue'
  end
end

Struct.new('Customer', :name, :address)

fork { exit 99 }
Process.wait

class Person
  # Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end

  attr_accessor :name
  attr_reader   :errors

  def validate!
    errors.add(:name, :blank, message: 'cannot be nil') if name.nil?
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def self.human_attribute_name(attr, options = {})
    attr
  end

  def self.lookup_ancestors
    [self]
  end
end

person = Person.new
person.validate!

class FakeConnection
  def combine_bind_parameters(a)
  end 
end

FakeKlass = Struct.new(:table_name, :name) do
  extend ActiveRecord::Delegation::DelegateCache

  inherited self

  def self.connection
    FakeConnection.new
  end

  def self.find_by_sql(a, b)
    return self
  end

  def self.arel_table
    'fake_table'
  end

  def self.sanitize_sql_for_order(sql)
    sql
  end
end

# http://apidock.com/rails/ActiveResource/Base/as_json
TEST_DATA = {
  Regexp: /test/,
  FalseClass: false,
  NilClass: nil,
  Object: Object.new,
  TrueClass: true,
  String: 'abc',
  StringChinese: '二胡',
  Numeric: 1,
  Symbol: :sym,
  Time: Time.new,
  Array: [1,2,3],
  Hash: {},
  HashNotEmpty: {a: 1},
  Date: Date.new,
  DateTime: DateTime.new,
  Enumerable: Colors.new,
  BigDecimal: '1'.to_d/3,
  BigDecimalInfinity: '0.5'.to_d/0,
  Struct: Struct::Customer.new('Dave', '123 Main'),
  Float: 1.0/3,
  FloatInfinity: 0.5/0,
  Range: (1..10),
  'Process::Status': $?,
  'ActiveSupport::TimeWithZone': Time.utc(2005,2,1,15,15,10).in_time_zone('Hawaii'),
  'ActiveModel::Errors': person.errors,
  'ActiveSupport::Duration': 1.month.ago,
  'ActiveSupport::Multibyte::Chars': 'über'.mb_chars,
  'ActiveRecord::Relation': ActiveRecord::Relation.new(FakeKlass, :b, nil),
  # 'ActionDispatch::Journey::GTG::TransitionTable': TODO,
}

require 'benchmark'
require 'benchmark/memory'

obj = TEST_DATA

Benchmark.memory do |x|
  x.report('to_json:'){ 10_000.times { obj.to_json } }
  x.report('Oj:') { 10_000.times { Oj.dump(obj) } }
  x.compare!
end

puts "---------------------------------------------\n\n"

Benchmark.benchmark(Benchmark::CAPTION, 14, Benchmark::FORMAT) do |x|
  x.report('to_json:'){ 10_000.times { obj.to_json } }
  x.report('Oj:') { 10_000.times { Oj.dump(obj) } }
end


# TEST_DATA.each do |key, val|
#   obj = val

#   puts "test for #{key} \n\n"

#   Benchmark.memory do |x|
#     x.report('to_json:'){ 10_000.times { obj.to_json } }
#     x.report('Oj:') { 10_000.times { Oj.dump(obj) } }
#     x.compare!
#   end

#   puts "---------------------------------------------\n\n"

#   Benchmark.benchmark(Benchmark::CAPTION, 14, Benchmark::FORMAT) do |x|
#     x.report('to_json:'){ 10_000.times { obj.to_json } }
#     x.report('Oj:') { 10_000.times { Oj.dump(obj) } }
#   end
# end
