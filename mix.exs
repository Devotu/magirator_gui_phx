defmodule MagiratorGuiPhx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :magirator_gui_phx,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MagiratorGuiPhx.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 1.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:poison, "~> 3.1"},
      {:bolt_sips, "~> 2.0"},
      {:ecto, "~> 3.0"},
      
      {:magirator_store, [path: "../magirator_store"]},
      {:magirator_calculator, [path: "../magirator_calculator"]},
      {:magirator_query, [path: "../magirator_query"]},
    ]
  end
end
