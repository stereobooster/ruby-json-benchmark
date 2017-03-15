require './test_data'
require 'terminal-table'

# helper
def compare(expected, result) 
  if result.is_a? Exception
    '💀'
  else
    expected == result ? '👌' : '❌'
  end
end

# def compare(expected, result) 
#   if result.is_a? Exception
#     'Error'
#   else
#     expected == result ? 'Ok' : 'Fail'
#   end
# end

# actual tests
test_result = TEST_DATA.map do |key, val|
  to_json_result = val.to_json
  
  json_generate_result = begin 
    JSON.generate(val)
  rescue JSON::GeneratorError => e
    e
  end

  Oj.default_options = OJ_1
  oj_dump_result_1 = begin
    Oj.dump(val)
  rescue NoMemoryError => e
    e
  rescue NotImplementedError => e
    e
  end

  Oj.default_options = OJ_2
  oj_dump_result_2 = begin
    Oj.dump(val)
  rescue NoMemoryError => e
    e
  rescue NotImplementedError => e
    e
  end

  Oj.default_options = OJ_3
  oj_dump_result_3 = begin
    Oj.dump(val)
  rescue NoMemoryError => e
    e
  rescue NotImplementedError => e
    e
  end

  [key, {
    to_json_result: to_json_result,
    json_generate: compare(to_json_result, json_generate_result),
    oj_dump_1: compare(to_json_result, oj_dump_result_1),
    oj_dump_2: compare(to_json_result, oj_dump_result_2),
    oj_dump_3: compare(to_json_result, oj_dump_result_3),
  }]
end.to_h

# format output
rows = test_result.map do |key, val|
  [key, val[:json_generate], val[:oj_dump_1], val[:oj_dump_2], val[:oj_dump_3]]
end

puts "\nComparing Rails to_json with other JSON implementations\n"
puts Terminal::Table.new headings: ['class', 'JSON.generate', 'Oj.dump object', 'Oj.dump compat', 'Oj.dump compat, as_json'], rows: rows
