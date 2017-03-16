# this is what Rails do in rails/activesupport/lib/active_support/core_ext/object/json.rb
module OjMimicTest
  def to_json(options = nil)
    p 1
    super options
  end
end

[Object, Array, FalseClass, Float, Hash, Integer, NilClass, String, TrueClass, Enumerable].reverse_each do |klass|
  klass.prepend(OjMimicTest)
end

# mimic_JSON 
require 'oj'
Oj.mimic_JSON()
begin
  require 'json'
rescue Exception
end

# testing
{}.to_json # this will print 1 in console

module OjMimicTest
  def to_json(options = nil)
    super options
  end
end

{}.to_json # this will **not** print 1 in console
