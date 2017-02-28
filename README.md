# Benchmark JSON implementations in Ruby

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
                 Oj:   800.000k memsize (     0.000  retained)
                        20.000k objects (     0.000  retained)
                         1.000  strings (     0.000  retained)

Comparison:
                 Oj::     800000 allocated
               JSON::    3440000 allocated - 4.30x more
            to_json::    8560000 allocated - 10.70x more
```

Speed:

```
---------------------------------------------

              user     system      total        real
to_json:  0.040000   0.000000   0.040000 (  0.047946)
JSON:     0.020000   0.000000   0.020000 (  0.016509)
Oj:       0.000000   0.000000   0.000000 (  0.001842)
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
