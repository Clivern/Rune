# Maps
#
# A map is a key-value collection that can grow and shrink. Atom keys have a
# convenient dot syntax. Any value can be a key, including strings.
#
# Run: elixir 12_maps/main.exs

user = %{name: "ada", city: "london"}
IO.inspect(user)
IO.puts(user.name)
IO.puts(user[:name])

# The | update syntax copies the map and replaces keys that already exist.
moved = %{user | city: "paris"}
IO.inspect(moved)

# Map.put adds a key or replaces one. Map.get takes a default for a missing key.
IO.inspect(Map.put(user, :age, 36))
IO.inspect(Map.get(user, :age, 0))

# String keys are not atom keys, and they have no dot syntax.
book = %{"title" => "Rune"}
IO.puts(book["title"])
