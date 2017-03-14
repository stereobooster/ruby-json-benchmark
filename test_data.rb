require 'rails/all'
require 'sqlite3'

OJ_1 = { mode: :object, use_as_json: false, float_precision: 16, bigdecimal_as_decimal: false, nan: :null, escape_mode: :xss_safe }
OJ_2 = { mode: :compat, use_as_json: false, float_precision: 16, bigdecimal_as_decimal: false, nan: :null, escape_mode: :xss_safe }
OJ_3 = { mode: :compat, use_as_json: true,  float_precision: 16, bigdecimal_as_decimal: false, nan: :null, escape_mode: :xss_safe }

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

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = 1

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database:':memory:'
)

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |table|
    table.column :name, :string
  end
end

class User < ActiveRecord::Base
  validates :name, presence: true
end

user = User.new
user.valid?

TEST_DATA = {
  Regexp: /test/,
  FalseClass: false,
  NilClass: nil,
  Object: Object.new,
  TrueClass: true,
  String: 'abc',
  StringChinese: '二胡',
  StringSpecial: "\u2028\u2029><&",
  Numeric: 1,
  Symbol: :sym,
  Time: Time.new,
  Array: [],
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
  # Complex: Complex('0.3-0.5i'),
  # Exception: Exception.new,
  # OpenStruct: OpenStruct.new(:country => "Australia", :population => 20_000_000),
  # Rational: Rational(0.3),
  'Process::Status': $?,
  'ActiveSupport::TimeWithZone': Time.utc(2005,2,1,15,15,10).in_time_zone('Hawaii'),
  'ActiveModel::Errors': user.errors,
  'ActiveSupport::Duration': 1.month.ago,
  'ActiveSupport::Multibyte::Chars': 'über'.mb_chars,
  'ActiveRecord::Relation': User.where(name: 'aaa'),
  # 'ActionDispatch::Journey::GTG::TransitionTable': TODO,
}
