defmodule VacuumCleaner.MixProject do
  use Mix.Project

  def project do
    [
      app: :vacuum_cleaner,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:stream_data, "~> 0.4", only: :test},
      {:mix_test_watch, "~> 0.9", only: :dev}
    ]
  end
end
