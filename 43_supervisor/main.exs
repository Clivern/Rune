# Supervisor
#
# A supervisor starts child processes and restarts them when they crash. The
# children are given as a list of {module, argument} pairs. strategy: :one_for_one
# restarts only the child that stopped.
#
# Run: elixir 43_supervisor/main.exs

defmodule Counter do
  use GenServer

  def start_link(n), do: GenServer.start_link(__MODULE__, n)

  @impl true
  def init(n), do: {:ok, n}

  @impl true
  def handle_cast(:inc, n), do: {:noreply, n + 1}

  @impl true
  def handle_call(:value, _from, n), do: {:reply, n, n}
end

{:ok, sup} = Supervisor.start_link([{Counter, 0}], strategy: :one_for_one)
IO.inspect(Supervisor.count_children(sup).workers)

# which_children returns the id, pid, type, and modules. We need the pid to
# talk to the counter the supervisor started.
[{_id, pid, :worker, _modules}] = Supervisor.which_children(sup)
GenServer.cast(pid, :inc)
IO.inspect(GenServer.call(pid, :value))
