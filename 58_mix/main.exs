# Mix
#
# Mix is Elixir's build tool. mix new creates a project. mix.exs names the
# application and its dependencies. config/config.exs holds settings compiled
# into the app. config/runtime.exs is read when the app starts, so it can use
# the environment. mix test runs the files in test/.
#
# This script is the entry point. The project it builds lives in app/.
#
# Run: elixir 58_mix/main.exs

app = Path.join(Path.dirname(__ENV__.file), "app")

{test_output, 0} =
  System.cmd("mix", ["test"],
    cd: app,
    stderr_to_stdout: true,
    env: [{"MIX_ENV", "test"}]
  )

summary =
  test_output
  |> String.split("\n", trim: true)
  |> Enum.find(&(&1 =~ ~r/\d+ tests?, \d+ failures/))

{run_output, 0} =
  System.cmd(
    "mix",
    ["run", "-e", "IO.puts(RuneDemo.greeting())\nIO.puts(RuneDemo.from_runtime())"],
    cd: app,
    stderr_to_stdout: true
  )

run_output =
  run_output
  |> String.split("\n")
  |> Enum.reject(
    &(&1 == "" or String.starts_with?(&1, "Compiling") or String.starts_with?(&1, "Generated"))
  )
  |> Enum.join("\n")

IO.puts(summary)
IO.puts(String.trim(run_output))
