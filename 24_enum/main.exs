# Enum
#
# Enum is the workhorse for lists, maps, ranges, and anything else that implements
# the Enumerable protocol. The functions are eager: they finish the whole
# collection before returning.
#
# Run: elixir 24_enum/main.exs

IO.inspect(Enum.map([1, 2, 3], &(&1 * 2)))
IO.inspect(Enum.filter([1, 2, 3, 4], &(rem(&1, 2) == 0)))
IO.inspect(Enum.reduce([1, 2, 3, 4], 0, &+/2))

# find returns the first matching value, or nil. any? and all? answer a yes or no
# question about the collection.
IO.inspect(Enum.find([1, 2, 3, 4], &(&1 > 2)))
IO.puts(Enum.any?([1, 2, 3], &(rem(&1, 2) == 0)))
IO.puts(Enum.all?([2, 4], &(rem(&1, 2) == 0)))

# Maps enumerate as {key, value} pairs.
names = Enum.map(%{a: 1, b: 2}, fn {key, value} -> "#{key}=#{value}" end)
IO.inspect(Enum.sort(names))
