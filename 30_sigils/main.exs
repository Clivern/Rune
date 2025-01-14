# Sigils
#
# A sigil is the ~ character followed by a letter and a delimited literal. The
# letter chooses the meaning. A lowercase letter interpolates #{}. An uppercase
# letter does not.
#
# Run: elixir 30_sigils/main.exs

# ~s is a string. ~S is a string without interpolation.
name = "rune"
IO.puts(~s(hello #{name}))
IO.puts(~S(hello #{name}))

# ~w splits text into a list of strings. A trailing a makes atoms, and c makes
# charlists.
IO.inspect(~w(one two three))
IO.inspect(~w(one two three)a)

# ~r builds a regular expression. ~c builds a charlist.
IO.inspect(Regex.run(~r/(\d+)/, "room 42"))
IO.inspect(~c"hello")

# Word lists and regexes are the sigils you will see most often. The delimiters
# can be parentheses, brackets, or slashes, as long as they match.
IO.inspect(~w[alpha beta])
