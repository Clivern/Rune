# Environment
#
# System talks to the operating system: environment variables, the clock, and
# the arguments the program was started with. Application environment is
# different. It is configuration stored inside the running BEAM, keyed by
# application and atom.
#
# Run: elixir 37_environment/main.exs one two

# The arguments after the script name are a list of strings.
IO.inspect(System.argv())

System.put_env("RUNE_EXAMPLE", "quartz")
IO.puts(System.get_env("RUNE_EXAMPLE"))
IO.inspect(System.get_env("RUNE_MISSING"))

# fetch_env! raises when the key was never set. put_env stores it for this
# operating-system process only.
Application.put_env(:rune, :greeting, "hello")
IO.puts(Application.fetch_env!(:rune, :greeting))
