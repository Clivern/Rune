# Iodata
#
# Iodata is a tree of binaries and bytes, nested in lists. Functions that write
# output accept it, so you can build a large message by nesting pieces instead
# of copying strings with <>.
#
# Run: elixir 56_iodata/main.exs

pieces = ["hello", ?\s, ["world", "!"]]
IO.puts(IO.iodata_length(pieces))
IO.puts(IO.iodata_to_binary(pieces))

# A byte is an integer from 0 to 255. ?\s is the code point of a space.
IO.inspect(?\s)
