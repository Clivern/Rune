# Defguard
#
# defguard names a guard check so it can be used in when clauses. The body of a
# guard is limited to the same expressions a guard allows. The generated macro
# is expanded at the call site.
#
# Run: elixir 57_defguard/main.exs

defmodule Number do
  defguard is_pos_int(n) when is_integer(n) and n > 0

  def kind(n) when is_pos_int(n), do: :positive
  def kind(0), do: :zero
  def kind(n) when is_integer(n), do: :negative
  def kind(_n), do: :other
end

IO.inspect(Number.kind(3))
IO.inspect(Number.kind(0))
IO.inspect(Number.kind(-1))
IO.inspect(Number.kind(1.5))
