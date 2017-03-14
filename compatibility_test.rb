require 'rubygems'
require 'terminal-table'
require 'oj'

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
    errors.add(:name, :blank, message: "cannot be nil") if name.nil?
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
    "fake_table"
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
  Array: [],
  Hash: {},
  HashNotEmpty: {a: 1},
  Date: Date.new,
  DateTime: DateTime.new,
  Enumerable: Colors.new,
  BigDecimal: '0.5'.to_d,
  BigDecimalInfinity: '0.5'.to_d/0,
  Struct: Struct::Customer.new('Dave', '123 Main'),
  Float: 0.5,
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

# helper
def compare(expected, result) 
  if result.is_a? Exception
    "💀"
  else
    expected == result ? "👌" : "❌"
  end
end

# actual tests
test_result = TEST_DATA.map do |key, val|
  to_json_result = val.to_json
  
  json_generate_result = begin 
    JSON.generate(val)
  rescue JSON::GeneratorError => e
    e
  end

  oj_dump_result = begin
    if key == :DateTime
      false
    else
      Oj.dump(val)
    end
  rescue NoMemoryError => e
    e
  end

  [key, {
    to_json_result: to_json_result,
    json_generate: compare(to_json_result, json_generate_result),
    oj_dump: compare(to_json_result, oj_dump_result),
  }]
end.to_h

# format output
rows = test_result.map do |key, val|
  [key, val[:json_generate], val[:oj_dump]]
end

puts "Comparing Rails to_json with other JSON implementations\n"
puts Terminal::Table.new headings: ['class', 'JSON.generate', 'Oj.dump'], rows: rows
