# GenStage
#
# A producer holds events. A consumer asks for a number of them with demand.
# The producer sends only that many, then waits for more demand. This script
# asks for the whole list in one subscription.
#
# Run: mix run 65_genstage/main.exs

Logger.configure(level: :none)

defmodule CounterProducer do
  use GenStage

  def start_link(items), do: GenStage.start_link(__MODULE__, items)

  def init(items), do: {:producer, items}

  def handle_demand(demand, items) when demand > 0 do
    {taken, rest} = Enum.split(items, demand)
    {:noreply, taken, rest}
  end
end

defmodule Collector do
  use GenStage

  def start_link(parent), do: GenStage.start_link(__MODULE__, parent)
  def init(parent), do: {:consumer, parent}

  def handle_events(events, _from, parent) do
    send(parent, {:events, events})
    {:noreply, [], parent}
  end
end

{:ok, producer} = CounterProducer.start_link([1, 2, 3])
{:ok, consumer} = Collector.start_link(self())
GenStage.sync_subscribe(consumer, to: producer, max_demand: 10, min_demand: 0)

events =
  Enum.reduce_while(1..10, [], fn _, acc ->
    receive do
      {:events, batch} ->
        acc = acc ++ batch
        if length(acc) >= 3, do: {:halt, acc}, else: {:cont, acc}
    after
      1_000 -> {:halt, acc}
    end
  end)

IO.inspect(events)
