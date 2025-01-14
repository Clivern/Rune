# Tuples
#
# A tuple groups a fixed number of values. Reading or replacing an element by
# position is cheap, which makes tuples the right shape for a pair such as
# {:ok, value} or a point.
#
# Run: elixir 10_tuples/main.exs

point = {3, 4}
IO.inspect(point)
IO.puts(tuple_size(point))
IO.inspect(elem(point, 0))

# put_elem returns a new tuple. point itself does not change.
IO.inspect(put_elem(point, 0, 9))
IO.inspect(point)

# Matching a tagged tuple is how Elixir handles a result.
{:ok, value} = {:ok, "saved"}
IO.puts(value)
