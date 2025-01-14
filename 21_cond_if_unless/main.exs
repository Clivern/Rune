# Cond, If, and Unless
#
# cond runs the first clause whose condition is truthy. if and unless are for a
# single test. nil and false are falsy. Every other value, including 0 and "", is
# truthy.
#
# Run: elixir 21_cond_if_unless/main.exs

defmodule Grade do
  def of(score) do
    cond do
      score >= 90 -> :a
      score >= 80 -> :b
      score >= 70 -> :c
      true -> :d
    end
  end
end

IO.inspect(Grade.of(91))
IO.inspect(Grade.of(75))
IO.inspect(Grade.of(50))

# if returns the value of the branch that ran. The else branch is optional and
# defaults to nil.
IO.puts(if 1 > 0, do: "yes", else: "no")
IO.inspect(if false, do: "yes")

# unless is if with the test negated.
IO.puts(unless 1 == 2, do: "different")

# 0 is truthy. A numeric zero does not take the else branch.
IO.puts(if 0, do: "zero is truthy", else: "falsy")
