# gen_statem
#
# :gen_statem is a state machine. In :state_functions mode, the current state
# is the name of the function that handles the next event. A call event arrives
# as {:call, from}. The reply is an action, not the return value itself.
#
# Run: elixir 64_gen_statem/main.exs

defmodule Switch do
  def start_link, do: :gen_statem.start_link(__MODULE__, nil, [])
  def flip(pid), do: :gen_statem.call(pid, :flip)

  def callback_mode, do: :state_functions
  def init(_), do: {:ok, :off, nil}

  def off({:call, from}, :flip, data) do
    {:next_state, :on, data, [{:reply, from, :on}]}
  end

  def on({:call, from}, :flip, data) do
    {:next_state, :off, data, [{:reply, from, :off}]}
  end
end

{:ok, pid} = Switch.start_link()
IO.inspect(Switch.flip(pid))
IO.inspect(Switch.flip(pid))
