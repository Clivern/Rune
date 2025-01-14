# Agents
#
# An Agent is a process that holds a value. You read it with get and replace it
# with update. The functions you pass run inside the agent, so the value never
# leaves the process unless you return it.
#
# Run: elixir 41_agents/main.exs

{:ok, bucket} = Agent.start_link(fn -> %{visits: 0} end)

Agent.update(bucket, fn state ->
  Map.update!(state, :visits, &(&1 + 1))
end)

Agent.update(bucket, fn state ->
  Map.update!(state, :visits, &(&1 + 1))
end)

IO.inspect(Agent.get(bucket, fn state -> state end))
IO.inspect(Agent.get(bucket, & &1.visits))

# get_and_update changes the state and returns the reply from the tuple.
previous =
  Agent.get_and_update(bucket, fn state ->
    {state.visits, %{state | visits: state.visits + 1}}
  end)

IO.inspect(previous)
IO.inspect(Agent.get(bucket, & &1.visits))
