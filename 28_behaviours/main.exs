# Behaviours
#
# A behaviour is a contract: a module lists the callbacks another module must
# implement. The compiler warns when an implementation is missing. GenServer and
# Supervisor are behaviours, and you can define your own.
#
# Run: elixir 28_behaviours/main.exs

defmodule Parser do
  @callback parse(String.t()) :: {:ok, term()} | :error
end

defmodule LineParser do
  @behaviour Parser

  @impl true
  def parse(text) do
    {:ok, String.split(text, ",", trim: true)}
  end
end

IO.inspect(LineParser.parse("a,b,c"))

# The behaviour does not dispatch for you. You call the implementation module.
# The callback list is what the compiler checks.
IO.inspect(Parser.behaviour_info(:callbacks))
