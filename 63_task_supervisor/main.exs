# Task.Supervisor
#
# Task.Supervisor starts tasks as supervised children. async runs a function in
# a new process and await returns its result. A task that has finished is no
# longer a child. If the task crashes, await exits with the same reason.
#
# Run: elixir 63_task_supervisor/main.exs

{:ok, sup} = Task.Supervisor.start_link()
task = Task.Supervisor.async(sup, fn -> Enum.sum(1..100) end)
IO.inspect(Task.await(task))
IO.inspect(Task.Supervisor.children(sup) |> length())
