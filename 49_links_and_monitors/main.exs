# Links and Monitors
#
# A link couples two processes: if one exits abnormally, the other exits too,
# unless it is trapping exits. A monitor is one way. The watcher is told that
# the other process stopped, and nothing happens to the watcher itself.
#
# Run: elixir 49_links_and_monitors/main.exs

Process.flag(:trap_exit, true)

linked =
  spawn_link(fn ->
    exit(:boom)
  end)

receive do
  {:EXIT, ^linked, reason} -> IO.inspect(reason)
after
  1_000 -> IO.puts("no exit signal")
end

child =
  spawn(fn ->
    receive do
      :stop -> :ok
    end
  end)

ref = Process.monitor(child)
send(child, :stop)

receive do
  {:DOWN, ^ref, :process, ^child, reason} -> IO.inspect(reason)
after
  1_000 -> IO.puts("no down signal")
end
