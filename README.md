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
| FloatInfinity                   | 💀            | ❌               | ❌               | ❌                        |
| Range                           | 👌            | ❌               | 👌               | 👌                        |
| Process::Status                 | ❌            | ❌               | ❌               | 👌                        |
| ActiveSupport::TimeWithZone     | ❌            | ❌               | ❌               | 👌                        |
| ActiveModel::Errors             | ❌            | 💀               | 💀               | 👌                        |
| ActiveSupport::Duration         | ❌            | ❌               | ❌               | 👌                        |
| ActiveSupport::Multibyte::Chars | 👌            | ❌               | ❌               | 👌                        |
| ActiveRecord::Relation          | ❌            | ❌               | ❌               | 👌                        |
+---------------------------------+---------------+------------------+------------------+---------------------------+
```


## With Rails

Memory:

```
ruby test.rb
Calculating -------------------------------------
            to_json:     8.560M memsize (     0.000  retained)
                       120.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
               JSON:     3.440M memsize (     0.000  retained)
                        40.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
     JSON + as_json:     4.240M memsize (     0.000  retained)
                        60.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
                 Oj:   800.000k memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
       Oj + as_json:     1.600M memsize (     0.000  retained)
                        40.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)

Comparison:
                 Oj::     800000 allocated
       Oj + as_json::    1600000 allocated - 2.00x more
               JSON::    3440000 allocated - 4.30x more
     JSON + as_json::    4240000 allocated - 5.30x more
            to_json::    8560000 allocated - 10.70x more
```

Speed:

```
---------------------------------------------

                     user     system      total        real
to_json:         0.050000   0.000000   0.050000 (  0.051194)
JSON:            0.010000   0.000000   0.010000 (  0.016290)
JSON + as_json:  0.030000   0.000000   0.030000 (  0.026652)
Oj:              0.000000   0.000000   0.000000 (  0.001867)
Oj + as_json:    0.020000   0.000000   0.020000 (  0.024057)
```

## Without Rails

Memory:
```
ruby test.rb
Calculating -------------------------------------
            to_json:     3.440M memsize (     0.000  retained)
                        40.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
               JSON:     3.440M memsize (     0.000  retained)
                        40.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
                 Oj:   800.000k memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)

Comparison:
                 Oj::     800000 allocated
               JSON::    3440000 allocated - 4.30x more
            to_json::    3440000 allocated - 4.30x more
```

Speed:
```
---------------------------------------------

              user     system      total        real
to_json:  0.020000   0.000000   0.020000 (  0.019824)
JSON:     0.020000   0.000000   0.020000 (  0.019611)
Oj:       0.000000   0.000000   0.000000 (  0.007160)
```

## With Rails and mimic_JSON

Memory:
```
Calculating -------------------------------------
            to_json:     5.920M memsize (     0.000  retained)
                       100.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
               JSON:   800.000k memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
     JSON + as_json:     1.600M memsize (     0.000  retained)
                        40.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
                 Oj:   800.000k memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
       Oj + as_json:     1.600M memsize (     0.000  retained)
                        40.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)

Comparison:
                 Oj::     800000 allocated
               JSON::     800000 allocated - same
       Oj + as_json::    1600000 allocated - 2.00x more
     JSON + as_json::    1600000 allocated - 2.00x more
            to_json::    5920000 allocated - 7.40x more
```

Speed:
```
---------------------------------------------

                     user     system      total        real
to_json:         0.030000   0.000000   0.030000 (  0.030054)
JSON:            0.000000   0.000000   0.000000 (  0.001865)
JSON + as_json:  0.010000   0.000000   0.010000 (  0.010314)
Oj:              0.000000   0.000000   0.000000 (  0.001790)
Oj + as_json:    0.010000   0.000000   0.010000 (  0.009895)
```

## With Rails and mimic_JSON and more complicated obj

Using `obj = {some: "fake", data: 1}` instead of `obj = {}`

Memory:
```
Calculating -------------------------------------
            to_json:    18.730M memsize (     0.000  retained)
                       270.000k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)
               JSON:   800.000k memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
     JSON + as_json:     8.890M memsize (     0.000  retained)
                       120.000k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)
                 Oj:   800.000k memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)
       Oj + as_json:     8.890M memsize (     0.000  retained)
                       120.000k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)

Comparison:
                 Oj::     800000 allocated
               JSON::     800000 allocated - same
       Oj + as_json::    8890000 allocated - 11.11x more
     JSON + as_json::    8890000 allocated - 11.11x more
            to_json::   18730000 allocated - 23.41x more
```

Speed:
```
---------------------------------------------

                     user     system      total        real
to_json:         0.090000   0.000000   0.090000 (  0.096543)
JSON:            0.010000   0.000000   0.010000 (  0.010220)
JSON + as_json:  0.090000   0.010000   0.100000 (  0.100630)
Oj:              0.000000   0.000000   0.000000 (  0.001923)
Oj + as_json:    0.030000   0.000000   0.030000 (  0.033553)
```
