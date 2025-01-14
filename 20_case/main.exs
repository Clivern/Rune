# Case
#
# case matches a value against patterns, top to bottom, and runs the body of the
# first match. Use it when one value can take several shapes.
#
# Run: elixir 20_case/main.exs

defmodule Outcome do
  def text(result) do
    case result do
      {:ok, value} -> "got #{value}"
      {:error, reason} -> "failed: #{reason}"
      other -> "unexpected #{inspect(other)}"
    end
  end
end

IO.puts(Outcome.text({:ok, 42}))
IO.puts(Outcome.text({:error, :missing}))
IO.puts(Outcome.text(:timeout))

# A guard can reject a match that fit the pattern.
defmodule Bucket do
  def take(map, key) do
    case Map.fetch(map, key) do
      {:ok, n} when is_integer(n) and n > 0 -> {:ok, n}
      {:ok, _n} -> {:error, :not_positive}
      :error -> {:error, :missing}
    end
  end
end

IO.inspect(Bucket.take(%{a: 3}, :a))
IO.inspect(Bucket.take(%{a: 0}, :a))
IO.inspect(Bucket.take(%{}, :a))
