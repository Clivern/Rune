# Registry
#
# A Registry maps a key to a process. {:via, Registry, {registry, key}} is a
# name that start_link and GenServer.call both understand, so callers do not
# need to hold the pid.
#
# Run: elixir 62_registry/main.exs

{:ok, _} = Registry.start_link(keys: :unique, name: Rune.Reg)

{:ok, _pid} =
  Agent.start_link(fn -> 1 end, name: {:via, Registry, {Rune.Reg, :counter}})

IO.inspect(Registry.lookup(Rune.Reg, :counter) |> length())
IO.inspect(Agent.get({:via, Registry, {Rune.Reg, :counter}}, & &1))
IO.inspect(Registry.lookup(Rune.Reg, :missing))
