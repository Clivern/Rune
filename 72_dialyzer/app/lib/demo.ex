# twice/1 matches its spec. Dialyzer accepts the module when every spec does.
defmodule Demo do
  @spec twice(integer()) :: integer()
  def twice(n), do: n * 2
end
