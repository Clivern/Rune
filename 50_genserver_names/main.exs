# GenServer Names
#
# A GenServer can be registered under a name, usually its module. handle_info
# receives messages that were sent with send, rather than with call or cast.
# A call also accepts a timeout, in milliseconds.
#
# Run: elixir 50_genserver_names/main.exs

defmodule Counter do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  def inc, do: GenServer.cast(__MODULE__, :inc)
  def value, do: GenServer.call(__MODULE__, :value)

  @impl true
  def init(n), do: {:ok, n}

  @impl true
  def handle_cast(:inc, n), do: {:noreply, n + 1}

  @impl true
  def handle_call(:value, _from, n), do: {:reply, n, n}

  @impl true
  def handle_info(:tick, n), do: {:noreply, n + 1}
end

defmodule Slow do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, nil)
  @impl true
  def init(_), do: {:ok, nil}

  @impl true
  def handle_call(:wait, _from, state) do
    Process.sleep(200)
    {:reply, :ok, state}
  end
end

{:ok, _} = Counter.start_link([])
Counter.inc()
send(Counter, :tick)
IO.inspect(Counter.value())

{:ok, slow} = Slow.start_link([])

try do
  GenServer.call(slow, :wait, 20)
rescue
  _error -> IO.puts("call raised")
catch
  :exit, {:timeout, _call} -> IO.puts("timeout")
end
