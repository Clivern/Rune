# JSON
#
# The JSON module encodes Elixir values as text and decodes text back. Object
# keys become string keys in a map, not atoms. encode! and decode! raise when
# the value cannot be converted.
#
# Run: elixir 35_json/main.exs

user = %{"name" => "ada", "age" => 36}
text = JSON.encode!(user)
IO.puts(text)

{:ok, decoded} = JSON.decode(text)
IO.inspect(decoded)
IO.puts(decoded["name"])

# A list stays a list. Atoms other than true, false, and nil are not JSON values,
# so prefer strings and numbers at the boundary.
IO.puts(JSON.encode!([1, "two", true, nil]))
