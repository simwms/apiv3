defmodule Apiv3.Mixfile do
  use Mix.Project

  def project do
    [app: :apiv3,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Apiv3, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex, :comeonin, :fox, 
                    :cors_plug, :stripex, :gateway,
                    :timex, :tzdata, :faker]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 1.0"},
     {:phoenix_ecto, "~> 1.1"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.1"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:cowboy, "~> 1.0"},
     {:fox, "~> 0.1"},
     {:comeonin, "~> 1.1"},
     {:cors_plug, "~> 0.1.3"},
     {:timex, "~>0.19"},
     {:timex_ecto, "~> 0.5"},
     {:pipe, "~> 0.0.2"},
     {:faker, "~> 0.5"},
     {:stripex, "~>0.1"},
     {:gateway, "~>0.0.5"},
     {:exrm, "~> 0.19.9"}]
  end
end
