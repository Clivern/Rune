# Typespecs
#
# @spec declares the argument types and return type of a function. @type names a
# type you can reuse. Typespecs are documentation, and dialyzer can check them.
# They are not enforced when the code runs.
#
# Run: elixir 29_typespecs/main.exs

defmodule Account do
  @type id :: pos_integer()
  @type result :: {:ok, id()} | {:error, :invalid}

  @spec create(String.t()) :: result()
  def create(name) when is_binary(name) and name != "" do
    {:ok, byte_size(name)}
  end

  def create(_name) do
    {:error, :invalid}
  end
end

IO.inspect(Account.create("ada"))
IO.inspect(Account.create(""))
