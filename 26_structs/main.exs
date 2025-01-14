# Structs
#
# A struct is a map with a fixed set of atom keys, defined by defstruct, and a
# name which is the module. The defaults live in the definition. Access and
# matching work as they do for maps.
#
# Run: elixir 26_structs/main.exs

defmodule User do
  defstruct name: "anonymous", age: 0

  # demo runs after the module has been compiled, which is when the struct exists.
  def demo do
    ada = %User{name: "ada", age: 36}
    IO.inspect(ada)
    IO.puts(ada.name)

    # Updating a struct uses the same | syntax as a map.
    older = %{ada | age: 37}
    IO.inspect(older.age)

    # A struct match can require the module and bind the fields you care about.
    %User{name: name} = older
    IO.puts(name)

    # Underneath, a struct is a map with a __struct__ key. Map functions still work.
    IO.puts(ada.__struct__)
    IO.inspect(Map.get(ada, :name))
  end
end

User.demo()
