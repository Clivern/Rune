# Keyword Lists
#
# A keyword list is a list of two-element tuples whose first element is an atom.
# The bracket syntax is sugar for that list. Keys can repeat, and the order is
# kept, which is why options to functions are usually keyword lists.
#
# Run: elixir 11_keyword_lists/main.exs

options = [color: "blue", size: 4]
IO.inspect(options)
IO.inspect(options == [{:color, "blue"}, {:size, 4}])

# Access returns the first value for a key, or nil when the key is missing.
IO.puts(options[:color])
IO.inspect(options[:missing])
IO.inspect(Keyword.get(options, :size))

# Concatenating adds keys. get_values returns every value for a repeated key, in
# the order they appear.
more = options ++ [size: 8]
IO.inspect(Keyword.get_values(more, :size))
