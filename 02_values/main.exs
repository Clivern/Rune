# Values
#
# Elixir has a small set of basic values: integers, floats, booleans, nil, and
# strings. Names are bound to values. You do not declare a type.
#
# Run: elixir 02_values/main.exs

# Integers can be arbitrarily large. Floats are 64-bit. Underscores only group digits.
IO.inspect(42)
IO.inspect(1_000_000)
IO.inspect(3.14)

# true, false, and nil are atoms the language treats specially.
IO.inspect(true)
IO.inspect(nil)

# Strings are UTF-8 binaries, written in double quotes.
IO.inspect("elixir")

# Guards ask what kind of value you have. They are functions that return a boolean.
IO.puts(is_integer(42))
IO.puts(is_float(3.14))
IO.puts(is_boolean(true))
IO.puts(is_nil(nil))
IO.puts(is_binary("elixir"))
