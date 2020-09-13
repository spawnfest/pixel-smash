defmodule PixelSmash.Battles.Supervisor do
  use Supervisor

  alias PixelSmash.Battles

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      Battles.Matchmaking,
      Battles.BattleSupervisor
    ]

    Supervisor.start_link(children, strategy: :rest_for_one)
  end
end
