# Binaries
#
# A binary is a sequence of bytes, written with <<>>. Strings are binaries of
# UTF-8 text, so the same syntax matches bytes inside a string. The :: modifiers
# set the size and the type of a segment.
#
# Run: elixir 31_binaries/main.exs

IO.inspect(<<1, 2, 3>>)
IO.puts(byte_size(<<1, 2, 3>>))

# A string match can bind the first byte and leave the rest as a binary.
<<first, rest::binary>> = "hi"
IO.puts(first)
IO.puts(rest)

# An integer segment can name its width in bits. The default is 8 bits, one byte.
# These two 4-bit segments pack into a single byte.
IO.inspect(<<0b1111::4, 0b0001::4>>)

# A binary can be built from values the same way it is matched.
name = "ada"
IO.inspect(<<byte_size(name)::8, name::binary>>)
