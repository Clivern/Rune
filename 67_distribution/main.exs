# Distribution
#
# A node is a running VM with a name. --sname starts one and registers it with
# epmd. :erpc.call runs a function on a node and returns the result. This call
# targets the current node, which is enough to show the shape of the call.
#
# Run: elixir --sname rune67 --cookie rune 67_distribution/main.exs

IO.puts(Node.alive?())
IO.inspect(:erpc.call(Node.self(), fn -> 1 + 1 end))
