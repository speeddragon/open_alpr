defmodule OpenALPR.MixProject do
  use Mix.Project

  def project do
    [
      app: :open_alpr,
      version: "0.1.0",
      elixir: "~> 1.6",
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
      {:httpoison, "~> 1.0"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:bypass, "~> 1.0", only: :test}
    ]
  end
end
