defmodule Examples.MixProject do
  use Mix.Project

  def project do
    [
      app: :momento_examples,
      version: "0.1.0",
      elixir: "~> 1.14",
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
      {:gomomento, path: "../src"},
      {:tls_certificate_check, "~> 1.19"},
      # {:hdr_histogram, "~> 0.5.0"}
      {:hdr_histogram, path: "../../hdr_histogram_erl"}
    ]
  end
end
