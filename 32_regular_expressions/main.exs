# Regular Expressions
#
# ~r builds a Regex, and the Regex module runs it. run returns the matched text
# and any captures. replace substitutes matches. named captures come back as a
# map of string keys.
#
# Run: elixir 32_regular_expressions/main.exs

IO.inspect(Regex.run(~r/room (\d+)/, "room 42 is open"))
IO.puts(Regex.replace(~r/cat/, "one cat, two cats", "dog"))

# The u modifier turns on Unicode. Named captures use ?<name>.
email = ~r/^(?<user>[^@]+)@(?<host>.+)$/u
IO.inspect(Regex.named_captures(email, "ada@london.test"))

# scan finds every match instead of stopping at the first.
IO.inspect(Regex.scan(~r/\d+/, "a1 b22 c3"))
