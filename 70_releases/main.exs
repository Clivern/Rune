# Releases
#
# mix release assembles the compiled application, the Erlang runtime, and a
# start script into one directory. bin/rune_release eval runs an expression
# inside that release, without a Mix project on the machine that runs it.
#
# The project being released is app/. This script builds it and prints the
# result of the eval.
#
# Run: elixir 70_releases/main.exs

app = Path.join(Path.dirname(__ENV__.file), "app")

{_build_output, 0} =
  System.cmd("mix", ["release", "--overwrite"],
    cd: app,
    stderr_to_stdout: true,
    env: [{"MIX_ENV", "prod"}]
  )

bin = Path.join([app, "_build", "prod", "rel", "rune_release", "bin", "rune_release"])
{eval_output, 0} = System.cmd(bin, ["eval", "IO.puts(:released)"], stderr_to_stdout: true)
IO.write(eval_output)
