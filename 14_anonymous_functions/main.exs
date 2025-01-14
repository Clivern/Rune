# Anonymous Functions
#
# fn builds a function value. You call it with a dot before the parentheses.
# The & capture operator is a shorter way to write a function that only wraps
# an expression or an existing function.
#
# Run: elixir 14_anonymous_functions/main.exs

add = fn a, b -> a + b end
IO.inspect(add.(1, 2))

# &1 is the first argument. &2 would be the second.
square = &(&1 * &1)
IO.inspect(square.(4))

# &Module.fun/arity captures a named function as a value.
double = &Kernel.*/2
IO.inspect(double.(21, 2))

# Enum.map takes a function and builds a new list from its results.
IO.inspect(Enum.map([1, 2, 3], &(&1 + 1)))

# A function can have several clauses, tried from top to bottom.
describe = fn
  0 -> "zero"
  n when n < 0 -> "negative"
  n -> "positive #{n}"
end

IO.puts(describe.(0))
IO.puts(describe.(-2))
IO.puts(describe.(5))
