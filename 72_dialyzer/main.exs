# Dialyzer
#
# Dialyzer checks @spec annotations against the code that was compiled. It
# reads a PLT, a cache of results for the standard library, and then looks at
# this project's modules. A success line means the specs it checked agree with
# the implementation.
#
# The module under check is app/lib/demo.ex.
#
# Run: elixir 72_dialyzer/main.exs

app = Path.join(Path.dirname(__ENV__.file), "app")

{_, 0} = System.cmd("mix", ["deps.get", "--quiet"], cd: app, stderr_to_stdout: true)

{output, status} =
  System.cmd("mix", ["dialyzer", "--format", "short"],
    cd: app,
    stderr_to_stdout: true
  )

lines =
  output
  |> String.split("\n", trim: true)
  |> Enum.filter(&(&1 =~ "Total errors" or &1 =~ "done (passed" or &1 =~ ":invalid_contract"))

IO.write(Enum.join(lines, "\n"))
IO.puts("")

if status != 0 and lines == [] do
  IO.write(output)
  System.halt(status)
end
