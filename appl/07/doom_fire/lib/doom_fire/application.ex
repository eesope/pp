defmodule DoomFire.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DoomFireWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:doom_fire, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DoomFire.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DoomFire.Finch},
      # Start a worker by calling: DoomFire.Worker.start_link(arg)
      # {DoomFire.Worker, arg},
      # Start to serve requests, typically the last entry
      DoomFireWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DoomFire.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DoomFireWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
