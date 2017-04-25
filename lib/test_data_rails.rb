# encoding: utf-8
require 'rails/all'
require 'sqlite3'

ENV['RAILS_ENV'] = 'production'
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = 1
ActiveRecord::Migration.verbose = false

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database:':memory:'
)
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

TEST_DATA_RAILS = {
  'ActiveSupport::TimeWithZone': Time.utc(2005,2,1,15,15,10).in_time_zone('Hawaii'),
  'ActiveModel::Errors': user.errors,
  'ActiveSupport::Duration': 1.month.ago,
  'ActiveSupport::Multibyte::Chars': 'über'.mb_chars,
  'ActiveRecord::Relation': User.where(name: 'aaa'),
  'ActiveRecord': User.find_or_create_by(name: "John")
  # 'ActionDispatch::Journey::GTG::TransitionTable': TODO,
}
