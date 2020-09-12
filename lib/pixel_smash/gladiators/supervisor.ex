defmodule PixelSmash.Gladiators.Supervisor do
  use Supervisor

  alias PixelSmash.Gladiators

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      Gladiators.Store
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
