# Macros
#
# quote turns code into an AST, a nested tuple of three elements:
# {function, meta, arguments}. unquote splices a value back into a quoted
# block. defmacro defines a macro, which receives quoted arguments and returns
# quoted code for the caller to compile.
#
# Run: elixir 59_macros/main.exs

quoted = quote do: 1 + 2
IO.inspect(quoted)
IO.inspect(quoted |> Code.eval_quoted() |> elem(0))

defmodule Logic do
  defmacro unless(condition, do: body) do
    quote do
      if !unquote(condition), do: unquote(body)
    end
  end
end

defmodule Demo do
  require Logic

  def run do
    Logic.unless false do
      IO.puts("ran")
    end

    Logic.unless true do
      IO.puts("skipped")
    end
  end
end

Demo.run()
