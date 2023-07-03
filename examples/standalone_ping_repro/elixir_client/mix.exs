defmodule StandalonePingRepro.MixProject do
  use Mix.Project

  def project do
    [
      app: :standalone_ping_repro,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(_), do: ["lib", "generated"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:grpc, "0.6.0"},
      {:protobuf, "~> 0.12.0"},
      #{:tls_certificate_check, "~> 1.19"}
      {:certifi, "~> 2.11"}
    ]
  end
end
