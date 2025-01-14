# The project file. app: is the name Application.fetch_env! looks up.
defmodule RuneDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :rune_demo,
      version: "0.1.0",
      elixir: "~> 1.19",
      deps: []
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end
end
