defmodule Rune.MixProject do
  use Mix.Project

  @version "0.1.1"
  @url_docs "http://hexdocs.pm/rune"
  @url_github "https://github.com/clivern/rune"

  def project do
    [
      app: :rune,
      name: "Rune",
      description: "Learning elixir",
      package: %{
        files: [
          "lib",
          "mix.exs",
          "LICENSE"
        ],
        licenses: ["MIT"],
        links: %{
          "Docs" => @url_docs,
          "GitHub" => @url_github
        },
        maintainers: ["Clivern"]
      },
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      compilers: [] ++ Mix.compilers(),
      deps: deps(),
      docs: [
        source_ref: "v#{@version}",
        source_url: @url_github,
        main: "Rune",
        extras: ["README.md"]
      ],
      preferred_cli_env: [
        docs: :docs
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.34", only: [:dev], runtime: false}
    ]
  end
end
