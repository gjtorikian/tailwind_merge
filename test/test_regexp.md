find:

```
expect\(twMerge\("(.+?)"\)\).toBe\(
      "(.+?)".
    \)
```

replace:

```
assert_equal("$2", @merger.merge("$1"))
```
