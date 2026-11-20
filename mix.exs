defmodule Rune.MixProject do
  use Mix.Project

  def project do
    [
      app: :rune,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:gen_stage, "~> 1.2"},
      {:broadway, "~> 1.2"},
      {:telemetry, "~> 1.3"},
      {:ecto, "~> 3.13"},
      {:phoenix, "~> 1.8.0"},
      {:phoenix_live_view, "~> 1.0"},
      {:lazy_html, "~> 0.1"}
    ]
  end
end
