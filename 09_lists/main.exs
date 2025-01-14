# Lists
#
# A list is a linked sequence, written in square brackets. Adding to the front is
# cheap. Adding to the end copies the list, so ++ belongs at the edges of a program
# rather than inside a loop.
#
# Run: elixir 09_lists/main.exs

items = [1, 2, 3]
IO.inspect(items)

# The cons operator | builds a new list with one element in front.
IO.inspect([0 | items])

# ++ concatenates. -- removes the first occurrence of each element on the right.
IO.inspect(items ++ [4])
IO.inspect([1, 2, 2, 3] -- [2])

# hd and tl are the head and the tail. length walks the whole list.
IO.puts(hd(items))
IO.inspect(tl(items))
IO.puts(length(items))

# A list of integers that are code points prints as a charlist. Inspect shows that.
IO.inspect([104, 101, 108, 108, 111])
