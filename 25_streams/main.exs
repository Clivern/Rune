# Streams
#
# A stream is a lazy enumerable. map and filter build a recipe, and nothing is
# computed until an eager function such as Enum.take asks for values. That lets
# you describe a huge or infinite sequence and use only a prefix of it.
#
# Run: elixir 25_streams/main.exs

squares =
  1..1_000_000
  |> Stream.map(&(&1 * &1))
  |> Stream.filter(&(rem(&1, 2) == 0))
  |> Enum.take(3)

IO.inspect(squares)

# Stream.cycle and Stream.iterate never end. take is what stops them.
IO.inspect(1..3 |> Stream.cycle() |> Enum.take(7))
IO.inspect(Stream.iterate(1, &(&1 * 2)) |> Enum.take(6))

# A pipeline that ends in Enum is still eager at that last step. The laziness is
# only in the Stream steps before it.
total =
  1..100
  |> Stream.map(&(&1 * &1))
  |> Enum.sum()

IO.puts(total)
