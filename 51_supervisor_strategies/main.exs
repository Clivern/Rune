# Supervisor Strategies
#
# :one_for_one restarts only the child that stopped. :one_for_all restarts every
# child. :rest_for_one restarts the child that stopped and the children started
# after it. Each worker reports its id to the parent every time it starts.
#
# Run: elixir 51_supervisor_strategies/main.exs

Logger.configure(level: :none)

defmodule Worker do
  use GenServer

  def start_link({parent, id}), do: GenServer.start_link(__MODULE__, {parent, id})

  @impl true
  def init({parent, id}) do
    send(parent, {:up, id})
    {:ok, {parent, id}}
  end

  @impl true
  def handle_cast(:crash, state), do: {:stop, :shutdown, state}
end

defmodule Demo do
  def restarts(strategy) do
    parent = self()

    children =
      for id <- [:a, :b] do
        %{id: id, start: {Worker, :start_link, [{parent, id}]}}
      end

    {:ok, sup} = Supervisor.start_link(children, strategy: strategy)
    _started = collect(2)

    [{_, pid, _, _}] =
      Enum.filter(Supervisor.which_children(sup), fn {id, _, _, _} -> id == :a end)

    GenServer.cast(pid, :crash)
    restarted = collect_available()
    Supervisor.stop(sup)
    {strategy, Enum.sort(restarted)}
  end

  defp collect(n) do
    Enum.map(1..n, fn _ ->
      receive do
        {:up, id} -> id
      after
        1_000 -> :timeout
      end
    end)
  end

  defp collect_available do
    receive do
      {:up, id} -> [id | collect_available()]
    after
      100 -> []
    end
  end
end

IO.inspect(Demo.restarts(:one_for_one))
IO.inspect(Demo.restarts(:one_for_all))
IO.inspect(Demo.restarts(:rest_for_one))
