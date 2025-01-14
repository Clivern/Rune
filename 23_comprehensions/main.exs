# Comprehensions
#
# for walks an enumerable, keeps the items that pass the filters, and builds a
# new collection from the do block. into chooses the collection to build. The
# default is a list.
#
# Run: elixir 23_comprehensions/main.exs

squares = for n <- 1..5, do: n * n
IO.inspect(squares)

# A filter is a second clause. Items that fail it are skipped.
odds = for n <- 1..6, rem(n, 2) == 1, do: n
IO.inspect(odds)

# Several generators are nested. The rightmost one varies fastest.
pairs = for x <- 1..2, y <- [:a, :b], do: {x, y}
IO.inspect(pairs)

# into: %{} builds a map. The do block must return {key, value} pairs.
scaled = for {key, value} <- %{a: 1, b: 2}, into: %{}, do: {key, value * 10}
IO.inspect(scaled)
