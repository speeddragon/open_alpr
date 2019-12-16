defmodule OpenALPR.MixProject do
  use Mix.Project

  def project do
    [
      app: :open_alpr,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: [
        maintainers: ["David Magalhães"],
        licenses: ["MIT"],
        links: %{github: "https://github.com/speeddragon/open_alpr"}
      ],
      description: """
      Elixir interface for OpenALPR API.
      """,

      # Docs
      name: "Open ALPR",
      source_url: "https://github.com/speeddragon/open_alpr",
      docs: [main: "readme", extras: ["README.md"]]
    ]
  end

  def aliases do
    [compile: ["compile --warnings-as-errors"]]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev},
      {:httpoison, "~> 1.0"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:bypass, "~> 1.0", only: :test}
    ]
  end
end
