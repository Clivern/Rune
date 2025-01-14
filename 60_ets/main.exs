# ETS
#
# ETS is an in-memory table owned by a process. :set keeps one row per key.
# :protected lets any process read and only the owner write. The table is
# deleted when its owner exits.
#
# Run: elixir 60_ets/main.exs

table = :ets.new(:scores, [:set, :protected])
true = :ets.insert(table, {:ada, 10})
true = :ets.insert(table, {:ada, 12})

IO.inspect(:ets.lookup(table, :ada))
IO.inspect(:ets.lookup(table, :grace))
