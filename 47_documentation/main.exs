# Documentation
#
# @moduledoc documents the module and @doc documents the next function. An
# example indented under iex> is a doctest. ExUnit reads it from the compiled
# .beam file and fails if the expression does not return that value.
#
# Run: elixir 47_documentation/main.exs

dir = Path.join(System.tmp_dir!(), "rune-doctest")
File.rm_rf!(dir)
File.mkdir_p!(dir)

{output, 0} =
  System.cmd("elixirc", ["greeter.ex", "-o", dir],
    cd: Path.dirname(__ENV__.file),
    stderr_to_stdout: true
  )

if output != "", do: IO.write(output)
Code.append_path(dir)

ExUnit.start(autorun: false, seed: 0)

defmodule GreeterTest do
  use ExUnit.Case, async: false
  doctest Greeter
end

%{failures: 0} = ExUnit.run()
IO.puts(Greeter.hello("ada"))
