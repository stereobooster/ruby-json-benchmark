# Benchmark JSON implementations in Ruby

## Compatibility

Comparing Rails `to_json` with other JSON implementations:

```
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


## Benchmark Rails to_json vs compatible mode of Oj.dump

Memory:

```
ruby benchmark2.rb
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

## PS

There are other benchmars in `benchmark1.rb`, but they are not interesting me, because I was looking for comptible code.

