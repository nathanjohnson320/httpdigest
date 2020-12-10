defmodule Httpdigest.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :httpdigest,
      version: "0.0.3",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :crypto]]
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
  defp deps() do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  def description() do
    "Generates headers for HTTP Digest authentication."
  end

  def package() do
    [
      name: "httpdigest",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Nathan Johnson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nathanjohnson320/httpdigest"}
    ]
  end
end
