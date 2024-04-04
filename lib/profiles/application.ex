defmodule Profiles.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ProfilesWeb.Telemetry,
      Profiles.Repo,
      {DNSCluster, query: Application.get_env(:profiles, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Profiles.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Profiles.Finch},
      # Start a worker by calling: Profiles.Worker.start_link(arg)
      # {Profiles.Worker, arg},
      # Start to serve requests, typically the last entry
      ProfilesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Profiles.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProfilesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
