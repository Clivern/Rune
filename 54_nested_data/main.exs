# Nested Data
#
# get_in, put_in, and update_in walk a path of keys. For maps and keyword lists
# the path is a list of keys. Access.at and Access.key choose a list index or a
# key that might be missing.
#
# Run: elixir 54_nested_data/main.exs

data = %{user: %{name: "ada", tags: ["elixir", "otp"]}}

IO.inspect(get_in(data, [:user, :name]))
IO.inspect(put_in(data, [:user, :name], "rune"))
IO.inspect(update_in(data, [:user, :tags], fn tags -> ["beam" | tags] end))

# The original map is unchanged. Each function returns a new structure.
IO.inspect(data.user.name)

users = [%{name: "ada"}, %{name: "grace"}]
IO.inspect(get_in(users, [Access.at(1), :name]))
IO.inspect(update_in(users, [Access.all(), :name], &String.upcase/1))
