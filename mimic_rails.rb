def mimic_rails
  require 'oj'
  if Rails::VERSION::MAJOR == 5 && RUBY_VERSION == "2.2.6"
    # see https://github.com/ohler55/oj/commit/050b4c70836394cffd96b63388ff0dedb8ed3558
    require 'oj/active_support_helper'
  end

  Oj.default_options = {
    float_precision: 16,
    bigdecimal_as_decimal: false,
    nan: :null,
    time_format: :xmlschema,
    second_precision: 3,
    escape_mode: :unicode_xss,
    mode: :compat, 
    use_as_json: true,
  }

  Oj.mimic_JSON()
  begin
    require 'json'
  rescue Exception
  end

  module ActiveSupport
    module ToJsonWithActiveSupportEncoder # :nodoc:
      def to_json(options = nil)
        super(options)
      end
    end
  end
end
