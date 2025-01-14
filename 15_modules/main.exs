# Modules
#
# defmodule groups named functions. def defines a public function and defp a
# private one, callable only inside the module. A function is identified by its
# name and its arity, the number of arguments.
#
# Run: elixir 15_modules/main.exs

defmodule Greeter do
  def hello(name) do
    phrase(name)
  end

  def hello do
    hello("world")
  end

  defp phrase(name) do
    "hello #{name}"
  end
end

IO.puts(Greeter.hello())
IO.puts(Greeter.hello("ada"))

# Greeter.phrase/1 is private.
# Greeter.phrase("ada")
# error: undefined function phrase/1
