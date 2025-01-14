# Tasks
#
# Task.async runs a function in a new process and links it to the caller.
# Task.await waits for the result and returns it. If the task crashes, the
# caller crashes too, which is what you want when the work is part of the
# same job.
#
# Run: elixir 40_tasks/main.exs

task = Task.async(fn -> Enum.sum(1..100) end)
IO.inspect(Task.await(task))

# async_stream runs the function over a collection, a few items at a time, and
# preserves input order in the results.
squares =
  1..4
  |> Task.async_stream(fn n -> n * n end)
  |> Enum.map(fn {:ok, n} -> n end)

IO.inspect(squares)

# Task.start is fire-and-forget. Use it only when you do not need the result
# and you do not need the caller to notice a crash.
{:ok, _pid} = Task.start(fn -> :ok end)
IO.puts("started")
