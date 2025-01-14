# GenServer
#
# A GenServer is a process with a standard loop. You call it with GenServer.call,
# which waits for a reply, or GenServer.cast, which does not. The callbacks run
# inside the server process, one at a time, and they return the next state.
#
# Run: elixir 42_genserver/main.exs

defmodule Counter do
  use GenServer

  def start_link(n), do: GenServer.start_link(__MODULE__, n)
  def inc(pid), do: GenServer.cast(pid, :inc)
  def value(pid), do: GenServer.call(pid, :value)

  @impl true
  def init(n), do: {:ok, n}

  @impl true
  def handle_cast(:inc, n), do: {:noreply, n + 1}

  @impl true
  def handle_call(:value, _from, n), do: {:reply, n, n}
end

{:ok, pid} = Counter.start_link(10)
Counter.inc(pid)
Counter.inc(pid)
IO.inspect(Counter.value(pid))
