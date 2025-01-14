# Immutability
#
# Data does not change in place. An operation returns a new value, and names can
# be rebound to that new value. The previous value is left alone for anyone else
# who still holds it.
#
# Run: elixir 13_immutability/main.exs

original = [1, 2, 3]
extended = [0 | original]
IO.inspect(original)
IO.inspect(extended)

# Rebinding a name does not walk the old value and change it.
numbers = [1, 2]
numbers = numbers ++ [3]
IO.inspect(numbers)

# The same rule makes sharing safe. map keeps its own list after we rebind ours.
shared = [1, 2]
map = %{items: shared}
shared = [0 | shared]
IO.inspect(shared)
IO.inspect(map)
