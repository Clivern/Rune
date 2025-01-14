# Numbers
#
# Integers and floats share the arithmetic operators. / always returns a float.
# div and rem keep the division in integers.
#
# Run: elixir 06_numbers/main.exs

IO.inspect(1 + 2 * 3)
IO.inspect(5 / 2)
IO.inspect(div(5, 2))
IO.inspect(rem(5, 2))

# 0x, 0o, and 0b select hexadecimal, octal, and binary.
IO.inspect(0xFF)
IO.inspect(0b1010)

# trunc drops the fraction. round goes to the nearest integer, with halves away
# from zero.
IO.inspect(trunc(3.9))
IO.inspect(round(3.5))
IO.inspect(trunc(-3.9))
