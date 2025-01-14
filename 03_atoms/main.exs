# Atoms
#
# An atom is a constant whose name is its value. Two atoms with the same spelling
# are always identical, so they are the usual way to tag a result such as :ok or
# :error.
#
# Run: elixir 03_atoms/main.exs

IO.inspect(:ok)
IO.inspect(:error)
IO.puts(:ok == :ok)

# An atom is not the string that looks like it.
IO.puts(:ok == "ok")

# true and false are atoms, and also booleans. Most atoms are not booleans.
IO.puts(is_atom(true))
IO.puts(is_boolean(:ok))
IO.puts(is_boolean(false))

# A tagged tuple pairs an atom with data. Pattern matching takes it apart later.
IO.inspect({:ok, "saved"})
