defmodule PixelSmash.Battles.Supervisor do
  use Supervisor

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: PixelSmash.Battles.DynamicSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
