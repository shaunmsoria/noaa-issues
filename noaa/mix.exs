defmodule Noaa.MixProject do
  use Mix.Project

  def project do
    [
      app: :noaa,
      escript: escript_config(),
      version: "0.1.0",
      name: "Noaa",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :elixir_xml_to_map]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.1"},
      {:elixir_xml_to_map, "~> 2.0"},
      {:json, "~> 1.4"},
      {:ex_doc, "~> 0.19"},
      {:earmark, "~> 1.4.38"}
    ]
  end

  defp escript_config do
    [
      main_module: Noaa.CLI
    ]
  end
end
