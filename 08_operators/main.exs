# Operators
#
# Elixir has two families of boolean operators. and, or, and not require real
# booleans. &&, ||, and ! accept any value and treat nil and false as the only
# falsy ones.
#
# Run: elixir 08_operators/main.exs

IO.puts(true and not false)
IO.puts(false or true)

# || returns the first truthy value. && returns the first falsy value, or the
# last value when every part is truthy.
IO.puts(nil || "fallback")
IO.puts(false && "skipped")
IO.puts("kept" && "also kept")

# == compares after converting numbers. === also requires the same type.
IO.puts(1 == 1.0)
IO.puts(1 === 1.0)

# Comparison is defined across types, so a mixed list sorts in one order:
# numbers, then atoms by name, then strings.
IO.inspect(Enum.sort([nil, 2, :a, "b", 1.0]))
