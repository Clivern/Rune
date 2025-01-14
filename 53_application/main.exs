# Application
#
# An Application is the start callback of a running system. start/2 builds the
# supervision tree and returns {:ok, pid}. The VM calls it when the application
# starts. This script calls the same callback directly.
#
# Run: elixir 53_application/main.exs

defmodule Counter do
  use Agent
  def start_link(n), do: Agent.start_link(fn -> n end, name: __MODULE__)
  def value, do: Agent.get(__MODULE__, & &1)
end

defmodule Rune.Example.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [{Counter, 0}]
    Supervisor.start_link(children, strategy: :one_for_one, name: Rune.Example.Supervisor)
  end
end

{:ok, _pid} = Rune.Example.Application.start(:normal, [])
IO.inspect(Counter.value())
IO.inspect(Process.whereis(Rune.Example.Supervisor) |> is_pid())
