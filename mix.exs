defmodule Structure.MixProject do
  use Mix.Project

  def project do
    [
      app: :structure,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: compiler_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    extra_apps =
      case Mix.env() do
        :test -> [:stream_data]
        _ -> []
      end

    [applications: [:logger | extra_apps]]
  end

  defp compiler_paths(:test), do: ["test/generators"] ++ compiler_paths(:prod)
  defp compiler_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.25.0", only: :dev},
      {:dialyxir, "~> 1.1.0", only: [:dev, :test]},
      {:stream_data, "~> 0.5.0", only: [:test]}
    ]
  end
end
