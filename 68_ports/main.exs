# Ports
#
# A port is a process that owns an external program. Port.open spawns it.
# The program's stdout arrives as a {:data, bytes} message. When the program
# exits, the port sends {:exit_status, code} if that option was set.
#
# Run: elixir 68_ports/main.exs

port = Port.open({:spawn, "printf hello"}, [:binary, :exit_status])

receive do
  {^port, {:data, data}} -> IO.puts(data)
after
  1_000 -> IO.puts("no data")
end

receive do
  {^port, {:exit_status, status}} -> IO.puts("exit #{status}")
after
  1_000 -> IO.puts("no exit")
end
