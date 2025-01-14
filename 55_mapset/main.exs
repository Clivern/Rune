# MapSet
#
# A MapSet stores unique values with no order you should rely on for program
# logic. MapSet.new drops duplicates. union, intersection, and difference
# combine two sets.
#
# Run: elixir 55_mapset/main.exs

numbers = MapSet.new([1, 2, 2, 3])
other = MapSet.new([3, 4])

IO.inspect(MapSet.to_list(numbers) |> Enum.sort())
IO.inspect(MapSet.member?(numbers, 2))
IO.inspect(MapSet.union(numbers, other) |> MapSet.to_list() |> Enum.sort())
IO.inspect(MapSet.intersection(numbers, other) |> MapSet.to_list())
IO.inspect(MapSet.difference(numbers, other) |> MapSet.to_list() |> Enum.sort())
