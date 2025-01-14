# Processes
#
# A process is a lightweight isolated thread of execution. spawn runs a function
# in a new process and returns its pid. Processes share nothing. They only
# communicate by messages, which the next example receives.
#
# Run: elixir 38_processes/main.exs

parent = self()
IO.puts(is_pid(parent))

# The child sends one message back and then exits. spawn returns as soon as the
# process is created. It does not wait for the function to finish.
child =
  spawn(fn ->
    send(parent, :finished)
  end)

IO.puts(is_pid(child))

receive do
  :finished -> IO.puts("child finished")
after
  1_000 -> IO.puts("timed out")
end
