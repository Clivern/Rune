# DynamicSupervisor
#
# A DynamicSupervisor starts children while the program is running. The
# children are not listed up front. start_child returns the new pid, and the
# supervisor restarts a child that crashes, using the same argument.
#
# Run: elixir 52_dynamic_supervisor/main.exs

defmodule Bucket do
  use Agent

  def start_link(n), do: Agent.start_link(fn -> n end)
  def value(pid), do: Agent.get(pid, & &1)
end

{:ok, sup} = DynamicSupervisor.start_link(strategy: :one_for_one)
{:ok, first} = DynamicSupervisor.start_child(sup, {Bucket, 1})
{:ok, _second} = DynamicSupervisor.start_child(sup, {Bucket, 2})

IO.inspect(DynamicSupervisor.count_children(sup).active)
IO.inspect(Bucket.value(first))
