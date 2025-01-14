# With
#
# with chains matches that depend on each other. When a clause matches, the next
# one runs. When a clause does not match, with returns that value immediately.
# It is the usual way to write a sequence of {:ok, value} steps.
#
# Run: elixir 22_with/main.exs

defmodule Profile do
  def name(data) do
    with {:ok, user} <- Map.fetch(data, :user),
         {:ok, name} <- Map.fetch(user, :name) do
      {:ok, name}
    end
  end

  # else handles the values that failed to match, instead of returning them as
  # they are.
  def label(data) do
    with {:ok, user} <- Map.fetch(data, :user),
         {:ok, name} <- Map.fetch(user, :name) do
      "name: #{name}"
    else
      :error -> "missing"
    end
  end
end

IO.inspect(Profile.name(%{user: %{name: "ada"}}))
IO.inspect(Profile.name(%{user: %{}}))
IO.inspect(Profile.name(%{}))

IO.puts(Profile.label(%{user: %{name: "ada"}}))
IO.puts(Profile.label(%{}))
