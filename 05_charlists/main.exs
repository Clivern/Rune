# Charlists
#
# A charlist is a list of Unicode code points, written with the ~c sigil. It is
# not a string. Charlists exist so Elixir can call Erlang libraries that expect
# them. Prefer double-quoted strings in your own code.
#
# Run: elixir 05_charlists/main.exs

IO.inspect(~c"hello")
IO.puts(is_list(~c"hello"))
IO.puts(is_binary("hello"))

# to_string and to_charlist convert between the two representations.
IO.puts(to_string(~c"hello"))
IO.inspect(to_charlist("hello"))

# IO.puts prints both as text. They still do not compare equal.
IO.puts(~c"hello")
IO.puts(~c"hello" == "hello")
