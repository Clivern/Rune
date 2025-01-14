# Strings
#
# Strings are UTF-8 binaries written in double quotes. <> concatenates them, and
# #{} interpolates a value into one.
#
# Run: elixir 04_strings/main.exs

name = "elixir"
IO.puts("hello " <> name)
IO.puts("hello #{name}")

# String.length counts graphemes. byte_size counts raw bytes. é is one character
# and two bytes.
IO.puts(String.length("héllo"))
IO.puts(byte_size("héllo"))

# The String module holds the usual text operations.
IO.puts(String.upcase("rune"))
IO.puts(String.contains?("elixir", "xi"))
IO.inspect(String.split("one two two", " "))

# A string is a binary, so a match can take a prefix and leave the rest.
"he" <> rest = "hello"
IO.puts(rest)
