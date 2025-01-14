# Persistent Term
#
# :persistent_term stores a value that many processes read and almost nobody
# writes. A read does not copy the term. Replacing a key is expensive, so the
# table suits configuration and other data that changes rarely.
#
# Run: elixir 61_persistent_term/main.exs

key = {__MODULE__, :greeting}
:persistent_term.put(key, "hello")
IO.puts(:persistent_term.get(key))
:persistent_term.erase(key)
IO.inspect(:persistent_term.get(key, :missing))
