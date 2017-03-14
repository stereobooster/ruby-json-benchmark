# Benchmark JSON implementations in Ruby

## Why

`to_json` in Rails project is not the same as `JSON.generate` or `to_json` in non-Rails project. See benchmarks [Rails to_json + Oj.mimic_JSON](https://github.com/stereobooster/ruby-json-benchmark#rails-to_json--ojmimic_json) vs [No Rails to_json + Oj.mimic_JSON](https://github.com/stereobooster/ruby-json-benchmark#no-rails-to_json--ojmimic_json) (bellow).

## Compatibility test

Comparing Rails `to_json` with other JSON implementations:

```
bundle exec ruby compatibility_test.rb
+---------------------------------+---------------+------------------+------------------+---------------------------+
| class                           | JSON.generate | Oj.dump (object) | Oj.dump (compat) | Oj.dump (compat, as_json) |
+---------------------------------+---------------+------------------+------------------+---------------------------+
| Regexp                          | 👌            | ❌               | ❌               | 👌                        |
| FalseClass                      | 👌            | 👌               | 👌               | 👌                        |
| NilClass                        | 👌            | 👌               | 👌               | 👌                        |
| Object                          | ❌            | ❌               | 👌               | 👌                        |
| TrueClass                       | 👌            | 👌               | 👌               | 👌                        |
| String                          | 👌            | 👌               | 👌               | 👌                        |
| StringChinese                   | 👌            | 👌               | 👌               | 👌                        |
| Numeric                         | 👌            | 👌               | 👌               | 👌                        |
| Symbol                          | 👌            | ❌               | 👌               | 👌                        |
| Time                            | ❌            | ❌               | ❌               | 👌                        |
| Array                           | 👌            | 👌               | 👌               | 👌                        |
| Hash                            | 👌            | 👌               | 👌               | 👌                        |
| HashNotEmpty                    | 👌            | ❌               | 👌               | 👌                        |
| Date                            | 👌            | ❌               | 👌               | 👌                        |
| DateTime                        | ❌            | 💀               | ❌               | 👌                        |
| Enumerable                      | ❌            | ❌               | ❌               | 👌                        |
| BigDecimal                      | 👌            | 👌               | 👌               | 👌                        |
| BigDecimalInfinity              | ❌            | ❌               | ❌               | 👌                        |
| Struct                          | ❌            | ❌               | ❌               | 👌                        |
| Float                           | 👌            | 👌               | 👌               | 👌                        |
| FloatInfinity                   | 💀            | ❌               | 👌               | 👌                        |
| Range                           | 👌            | ❌               | 👌               | 👌                        |
| Process::Status                 | ❌            | ❌               | ❌               | 👌                        |
| ActiveSupport::TimeWithZone     | ❌            | ❌               | ❌               | 👌                        |
| ActiveModel::Errors             | ❌            | 💀               | 💀               | 👌                        |
| ActiveSupport::Duration         | ❌            | ❌               | ❌               | 👌                        |
| ActiveSupport::Multibyte::Chars | 👌            | ❌               | ❌               | 👌                        |
| ActiveRecord::Relation          | ❌            | ❌               | ❌               | 👌                        |
+---------------------------------+---------------+------------------+------------------+---------------------------+
```

See comparison across Ruby/Rails version in [test_report.txt](test_report.txt). Report was generated with command: `wwtd &> test_report.txt`.

Tests based on [as_json](http://apidock.com/rails/ActiveResource/Base/as_json) implementations.

See also:
- [json gem](https://github.com/ruby/ruby/tree/202bbda2bf5f25343e286099140fb9282880ecba/ext/json/lib/json/add).
- [active_support/json/encoding.rb](https://github.com/rails/rails/blob/92703a9ea5d8b96f30e0b706b801c9185ef14f0e/activesupport/lib/active_support/json/encoding.rb)

## Benchmark Rails to_json vs compatible mode of Oj.dump

Memory:

```
bundle exec ruby benchmark2.rb
Calculating -------------------------------------
            to_json:   437.048M memsize (    30.968k retained)
                         8.341M objects (   117.000  retained)
                        50.000  strings (    42.000  retained)
                 Oj:   101.720M memsize (     0.000  retained)
                         1.590M objects (     0.000  retained)
                        38.000  strings (     0.000  retained)

Comparison:
                 Oj::  101720000 allocated
            to_json::  437048167 allocated - 4.30x more

---------------------------------------------

                     user     system      total        real
to_json:         3.410000   1.090000   4.500000 (  4.544330)
Oj:              0.720000   0.010000   0.730000 (  0.727759)
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
