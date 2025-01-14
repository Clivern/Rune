# Pipe Operator
#
# |> passes the result of the expression on its left as the first argument of the
# call on its right. A pipeline reads from top to bottom, in the order the data
# actually moves.
#
# Run: elixir 17_pipe/main.exs

result =
  "  Elixir  "
  |> String.trim()
  |> String.downcase()
  |> String.replace("e", "3")

IO.puts(result)

# The call above is the same as nested function calls, which hide the order.
IO.puts(String.replace(String.downcase(String.trim("  Elixir  ")), "e", "3"))

# Parentheses matter when the next call already has arguments. The piped value
# is inserted in front of them.
IO.inspect([1, 2, 3, 4] |> Enum.drop(2) |> Enum.map(&(&1 * 10)))
