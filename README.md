# Benchmark JSON implementations in Ruby

## Why

`to_json` in Rails project is not the same as `JSON.generate` or `to_json` in non-Rails project. See benchmarks [Rails to_json + Oj.mimic_JSON](https://github.com/stereobooster/ruby-json-benchmark#rails-to_json--ojmimic_json) vs [No Rails to_json + Oj.mimic_JSON](https://github.com/stereobooster/ruby-json-benchmark#no-rails-to_json--ojmimic_json) (below).

## Compatibility test

Comparing Rails `to_json` with other JSON implementations:

```
bundle exec ruby compatibility_test.rb
Comparing Rails to_json with other JSON implementations
+---------------------------------+--------------+---------+------------------+------------+-----------------+
| class                           | JSON to_json | Oj.dump | Oj::Rails.encode | Oj to_json | msgpack "rails" |
+---------------------------------+--------------+---------+------------------+------------+-----------------+
| Regexp                          | 👌           | 👌      | 👌               | 👌         | 👌              |
| FalseClass                      | 👌           | 👌      | 👌               | 👌         | 👌              |
| NilClass                        | 👌           | 👌      | 👌               | 👌         | 👌              |
| Object                          | ❌           | 👌      | 👌               | 👌         | 👌              |
| TrueClass                       | 👌           | 👌      | 👌               | 👌         | 👌              |
| String                          | 👌           | 👌      | 👌               | 👌         | 👌              |
| StringChinese                   | 👌           | 👌      | 👌               | 👌         | 👌              |
| StringSpecial                   | ❌           | ❌      | 👌               | 👌         | 👌              |
| StringSpecial2                  | 👌           | 👌      | 👌               | 👌         | 👌              |
| StringSpecial3                  | 👌           | 👌      | 👌               | 👌         | 👌              |
| Numeric                         | 👌           | 👌      | 👌               | 👌         | 👌              |
| Symbol                          | 👌           | 👌      | 👌               | 👌         | 👌              |
| Time                            | ❌           | 👌      | 👌               | 👌         | 👌              |
| Array                           | 👌           | 👌      | 👌               | 👌         | 👌              |
| Hash                            | 👌           | 👌      | 👌               | 👌         | 👌              |
| HashNotEmpty                    | 👌           | 👌      | 👌               | 👌         | 👌              |
| Date                            | 👌           | 👌      | 👌               | 👌         | 👌              |
| DateTime                        | ❌           | 👌      | 👌               | 👌         | 👌              |
| Enumerable                      | ❌           | 👌      | 👌               | 👌         | 👌              |
| BigDecimal                      | ❌           | 👌      | 👌               | 👌         | 👌              |
| BigDecimalInfinity              | ❌           | 👌      | 👌               | 👌         | 👌              |
| Struct                          | ❌           | 👌      | 👌               | 👌         | 👌              |
| Float                           | 👌           | 👌      | 👌               | 👌         | 👌              |
| FloatInfinity                   | 💀           | 👌      | 👌               | 👌         | ❌              |
| Range                           | 👌           | 👌      | 👌               | 👌         | 👌              |
| Complex                         | 👌           | ❌      | ❌               | 👌         | 👌              |
| Exception                       | ❌           | 👌      | 👌               | 👌         | 👌              |
| OpenStruct                      | ❌           | 👌      | 👌               | 👌         | 👌              |
| Rational                        | 👌           | ❌      | ❌               | 👌         | 👌              |
| Process::Status                 | ❌           | 👌      | 👌               | 👌         | 👌              |
| ActiveSupport::TimeWithZone     | ❌           | 👌      | 👌               | 👌         | 👌              |
| ActiveModel::Errors             | ❌           | 👌      | 👌               | 👌         | 👌              |
| ActiveSupport::Duration         | ❌           | 👌      | 👌               | 👌         | 👌              |
| ActiveSupport::Multibyte::Chars | ❌           | 👌      | 👌               | 👌         | 👌              |
| ActiveRecord::Relation          | ❌           | 👌      | 👌               | 👌         | 👌              |
| ActiveRecord                    | ❌           | 👌      | 👌               | 👌         | 👌              |
+---------------------------------+--------------+---------+------------------+------------+-----------------+
```

**Note**: msgpack is not JSON, so comparing results of serialization + deserialization e.g.

```ruby
ActiveSupport::JSON.decode(obj.to_json) vs MessagePack.unpack(obj.to_msgpack)
```

See comparison across Ruby/Rails version in [test_report.txt](test_report.txt). Report was generated with command: `wwtd &> test_report.txt`.

Tests based on [as_json](http://apidock.com/rails/ActiveResource/Base/as_json) implementations.

See also:
- [json gem](https://github.com/ruby/ruby/tree/202bbda2bf5f25343e286099140fb9282880ecba/ext/json/lib/json/add).
- [active_support/json/encoding.rb](https://github.com/rails/rails/blob/92703a9ea5d8b96f30e0b706b801c9185ef14f0e/activesupport/lib/active_support/json/encoding.rb)
- [lave](https://github.com/jed/lave)
- [Data formats](http://awesomeawesome.party/awesome-microservices#data-formats)

## Benchmark Rails to_json vs Oj.dump

```
Calculating -------------------------------------
            to_json:   340.131M memsize (   168.000  retained)
                         6.660M objects (     2.000  retained)
                        50.000  strings (     0.000  retained)
           Oj.dump o    55.880M memsize (     0.000  retained)
                       990.000k objects (     0.000  retained)
                        38.000  strings (     0.000  retained)
           Oj.dump c    55.880M memsize (     0.000  retained)
                       990.000k objects (     0.000  retained)
                        38.000  strings (     0.000  retained)
       Oj.dump c, aj    55.880M memsize (     0.000  retained)
                       990.000k objects (     0.000  retained)
                        38.000  strings (     0.000  retained)

Comparison:
       Oj.dump c, aj:   55880000 allocated
           Oj.dump o:   55880000 allocated - same
           Oj.dump c:   55880000 allocated - same
            to_json::  340130720 allocated - 6.09x more
---------------------------------------------

                     user     system      total        real
to_json:         2.810000   0.170000   2.980000 (  3.048407)
Oj.dump o        0.630000   0.020000   0.650000 (  0.666360)
Oj.dump c        0.440000   0.010000   0.450000 (  0.459752)
Oj.dump c, aj    0.530000   0.020000   0.550000 (  0.554771)
```

## Rails to_json + Oj.mimic_JSON

```
bundle exec ruby benchmark1.rb
Calculating -------------------------------------
            to_json:    18.730M memsize (     0.000  retained)
                       270.000k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)
               JSON:     2.970M memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
                 Oj:     2.970M memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)

Comparison:
                 Oj::    2970000 allocated
               JSON::    2970000 allocated - same
            to_json::   18730000 allocated - 6.31x more <---- PAY ATTENTION

---------------------------------------------

                     user     system      total        real
to_json:         0.080000   0.000000   0.080000 (  0.079702)
JSON:            0.010000   0.000000   0.010000 (  0.012702)
Oj:              0.020000   0.000000   0.020000 (  0.015271)
```

## No Rails to_json + Oj.mimic_JSON

```
bundle exec ruby benchmark1.rb
Calculating -------------------------------------
            to_json:     2.970M memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
               JSON:     2.970M memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
                 Oj:     2.970M memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)

Comparison:
            to_json::    2970000 allocated
               JSON::    2970000 allocated - same
                 Oj::    2970000 allocated - same

---------------------------------------------

                     user     system      total        real
to_json:         0.020000   0.000000   0.020000 (  0.014124)
JSON:            0.020000   0.010000   0.030000 (  0.024667)
Oj:              0.020000   0.000000   0.020000 (  0.028081)
```
