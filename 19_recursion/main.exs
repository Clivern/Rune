# Recursion
#
# Elixir has no while loop. You repeat work by calling a function from itself,
# with a clause that stops the recursion. Lists are walked by matching the head
# and recurring on the tail.
#
# Run: elixir 19_recursion/main.exs

defmodule Len do
  def of([]), do: 0
  def of([_head | tail]), do: 1 + of(tail)
end

IO.puts(Len.of([:a, :b, :c]))

# An accumulator carries the answer so far. This version is tail recursive: the
# recursive call is the last thing the clause does.
defmodule Sum do
  def of(list), do: of(list, 0)
  defp of([], total), do: total
  defp of([head | tail], total), do: of(tail, total + head)
end

IO.puts(Sum.of([1, 2, 3, 4]))
