# Alias, Import, Require, and Use
#
# Four directives change how a module refers to other modules. alias shortens a
# name. import makes functions callable without the module. require is needed
# before calling a macro. use invokes the other module's __using__ macro, which
# is how use GenServer injects code.
#
# Run: elixir 46_alias_import_require_use/main.exs

defmodule Greeter do
  def hello(name), do: "hello #{name}"

  defmacro twice(expr) do
    quote do
      unquote(expr)
      unquote(expr)
    end
  end

  defmacro __using__(_opts) do
    quote do
      def greet(name), do: "welcome #{name}"
    end
  end
end

defmodule Demo do
  alias Greeter, as: G
  import Greeter, only: [hello: 1]
  require Greeter
  use Greeter

  def run do
    Greeter.twice(IO.puts(hello("ada")))
    IO.puts(G.hello("rune"))
    IO.puts(greet("ada"))
  end
end

Demo.run()
