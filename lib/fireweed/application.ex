defmodule Fireweed.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    unless Mix.env == :prod do
      Envy.auto_load
    end

    children = [
      # Start the Ecto repository
      Fireweed.Repo,
      # Start the Telemetry supervisor
      FireweedWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Fireweed.PubSub},
      # Start the Endpoint (http/https)
      FireweedWeb.Endpoint,
      # Start a worker by calling: Fireweed.Worker.start_link(arg)
      # {Fireweed.Worker, arg}
      FatSecret
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fireweed.Supervisor]
    HTTPoison.start()
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FireweedWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
