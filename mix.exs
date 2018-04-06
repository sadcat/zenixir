defmodule NewTest.Mixfile do
  use Mix.Project

  def project do
    [app: :zenixir,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  defp description do
    """
    Elixir Zendesk API Client http://developer.zendesk.com/
    """
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 1.1"},
      {:poison, "~> 3.1"},
      {:exprintf, "~> 0.2.1"},
      {:exvcr, "~> 0.10", only: :test},
      {:excoveralls, "~> 0.8.1", only: :test},
      {:inch_ex, "~> 0.5.6", only: :docs},
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end
end
