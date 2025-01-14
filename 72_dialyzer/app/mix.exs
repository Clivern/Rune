defmodule DialyzerDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :dialyzer_demo,
      version: "0.1.0",
      elixir: "~> 1.19",
      deps: [{:dialyxir, "~> 1.4", only: [:dev], runtime: false}]
    ]
  end

  def application do
    [extra_applications: []]
  end
end
