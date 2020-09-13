defmodule PixelSmash.Wallets.Supervisor do
  use Supervisor

  alias PixelSmash.Wallets

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    children = [
      {Wallets.Vault, init_arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
