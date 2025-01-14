# Pattern Matching
#
# The = operator is the match operator. It binds names on the left to values on
# the right, and it fails when the two sides do not have the same shape.
#
# Run: elixir 07_pattern_matching/main.exs

x = 1
IO.inspect(x)

# Matching a value against itself succeeds and binds nothing new.
1 = x

# 2 = x
# error: no match of right hand side value: 1

# A tuple pattern pulls the elements out by position.
{a, b} = {1, 2}
IO.inspect({a, b})

# A list pattern can take the first element and the remaining list.
[head | tail] = [1, 2, 3]
IO.inspect(head)
IO.inspect(tail)

# A map pattern matches the keys you name and ignores the rest.
%{name: name} = %{name: "ada", city: "london"}
IO.puts(name)

# The pin operator ^ matches the current value of a name instead of rebinding it.
y = 1
^y = 1
IO.puts("pinned #{y}")
