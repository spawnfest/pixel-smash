defmodule PixelSmash.Application do
  @moduledoc false

  use Application

  alias PixelSmash.Battles

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PixelSmash.Repo,
      PixelSmash.MemoryRepo,
      # Start the Telemetry supervisor
      PixelSmashWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PixelSmash.PubSub},
      PixelSmash.Gladiators,
      PixelSmash.Battles,
      # Start the Endpoint (http/https)
      PixelSmashWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: PixelSmash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_phase(:schedule_series, :normal, _args) do
    Battles.schedule_series()
  end

  def config_change(changed, _new, removed) do
    PixelSmashWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
