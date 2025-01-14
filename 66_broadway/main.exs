# Broadway
#
# Broadway is a pipeline of producers and processors. Broadway.DummyProducer
# does not pull from an external source. test_message injects one message and
# the test process receives an acknowledgement with the processed data.
#
# Run: mix run 66_broadway/main.exs

Logger.configure(level: :none)

defmodule UpcasePipeline do
  use Broadway

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [module: {Broadway.DummyProducer, []}, concurrency: 1],
      processors: [default: [concurrency: 1]]
    )
  end

  @impl true
  def handle_message(_processor, message, _context) do
    Broadway.Message.update_data(message, &String.upcase/1)
  end
end

{:ok, _pid} = UpcasePipeline.start_link([])
ref = Broadway.test_message(UpcasePipeline, "hello")

receive do
  {:ack, ^ref, [message], []} -> IO.puts(message.data)
after
  2_000 -> IO.puts("no acknowledgement")
end
