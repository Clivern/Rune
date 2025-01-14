# The module and function docs live in a compiled file. A script module has no
# .beam on disk, and ExUnit reads the docs from that file.
defmodule Greeter do
  @moduledoc "Builds short greetings."

  # Lines indented four spaces, starting with iex>, are the doctest.
  @doc """
  Greets a person by name.

      iex> Greeter.hello("ada")
      "hello ada"

  """
  def hello(name), do: "hello #{name}"
end
