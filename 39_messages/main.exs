# Messages
#
# send drops a message into a process mailbox. receive waits until a message
# matches one of its patterns, then removes that message. Other messages stay
# in the mailbox. after gives up when nothing matches in time.
#
# Run: elixir 39_messages/main.exs

send(self(), {:result, 21})
send(self(), :ping)

# This receive skips :ping because it does not match, and takes the tuple.
receive do
  {:result, n} -> IO.puts(n * 2)
after
  1_000 -> IO.puts("no result")
end

# :ping is still there for a later receive.
receive do
  :ping -> IO.puts("pong")
after
  1_000 -> IO.puts("no ping")
end

# after runs when the mailbox has nothing that matches.
receive do
  :missing -> IO.puts("found")
after
  0 -> IO.puts("nothing waiting")
end
