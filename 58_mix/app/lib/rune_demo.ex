# fetch_env! raises if the key is missing, so a typo fails immediately.
defmodule RuneDemo do
  def greeting, do: Application.fetch_env!(:rune_demo, :greeting)
  def from_runtime, do: Application.fetch_env!(:rune_demo, :from_runtime)
end
