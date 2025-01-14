# Function Clauses
#
# A function can be defined several times. Elixir tries the clauses from top to
# bottom and runs the first one whose pattern and guard match. This replaces long
# chains of conditionals.
#
# Run: elixir 16_function_clauses/main.exs

defmodule Answer do
  def of(:ok, value), do: "ok #{value}"
  def of(:error, reason), do: "error #{reason}"
  def of(other), do: "unexpected #{inspect(other)}"
end

IO.puts(Answer.of(:ok, "saved"))
IO.puts(Answer.of(:error, "missing"))
IO.puts(Answer.of(42))

# A default argument is written with \\. It adds a clause of a smaller arity.
defmodule Join do
  def pair(left, right \\ "world") do
    "#{left} #{right}"
  end
end

IO.puts(Join.pair("hello"))
IO.puts(Join.pair("hello", "ada"))
