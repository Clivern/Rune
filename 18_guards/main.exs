# Guards
#
# A guard is a limited boolean check attached to a clause with when. Guards can
# test types and compare values. They cannot call your own functions, which keeps
# pattern matching predictable.
#
# Run: elixir 18_guards/main.exs

defmodule Number do
  def kind(n) when is_integer(n) and n < 0, do: :negative
  def kind(0), do: :zero
  def kind(n) when is_integer(n), do: :positive
  def kind(_other), do: :other
end

IO.inspect(Number.kind(-3))
IO.inspect(Number.kind(0))
IO.inspect(Number.kind(4))
IO.inspect(Number.kind(1.5))

# Several tests can be joined with and or or. A failing guard skips the clause
# instead of raising, and the next clause is tried.
defmodule Sign do
  def describe(n) when is_number(n) and n > 0, do: "positive number"
  def describe(n) when is_number(n), do: "not positive"
end

IO.puts(Sign.describe(2))
IO.puts(Sign.describe(-2))
