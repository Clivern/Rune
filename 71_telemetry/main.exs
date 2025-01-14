# Telemetry and Logger Metadata
#
# :telemetry.execute runs the functions attached to an event in the caller's
# process. The handler sees the event name, a map of measurements, and a map of
# metadata. Logger.metadata stores fields for the current process. A log line
# can include them, and any code in that process can read them back.
#
# Run: mix run 71_telemetry/main.exs

defmodule Handler do
  def handle(event, measurements, metadata, _config) do
    send(self(), {:handled, event, measurements.count, metadata.name})
  end
end

:telemetry.attach("rune-demo", [:rune, :demo], &Handler.handle/4, nil)

:telemetry.execute([:rune, :demo], %{count: 1}, %{name: "ada"})

receive do
  {:handled, event, count, name} ->
    IO.inspect(event)
    IO.inspect(count)
    IO.puts(name)
after
  1_000 ->
    IO.puts("no event")
end

:telemetry.detach("rune-demo")

Logger.metadata(request_id: "abc")
IO.puts(Logger.metadata()[:request_id])
