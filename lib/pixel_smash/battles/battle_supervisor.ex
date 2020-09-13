defmodule PixelSmash.Battles.BattleSupervisor do
  use DynamicSupervisor

  alias PixelSmash.Battles.{
    BattleServer,
    Fighter
  }

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def schedule_battle(supervisor \\ __MODULE__, {%Fighter{} = left, %Fighter{} = right}) do
    DynamicSupervisor.start_child(supervisor, {BattleServer, {left, right}})
  end

  def list_battle_servers(supervisor \\ __MODULE__) do
    DynamicSupervisor.which_children(supervisor)
    |> Enum.filter(fn
      {_, pid, :worker, _} when is_pid(pid) -> true
      _ -> false
    end)
    |> Enum.map(fn {_, pid, :worker, _} -> pid end)
  end

  def get_battle_server(supervisor \\ __MODULE__, id) do
    list_battle_servers(supervisor)
    |> Enum.map(&{&1, BattleServer.get_battle(&1)})
    |> Enum.find(fn {_, battle} -> battle.id == id end)
  end

  def terminate_battle_server(supervisor \\ __MODULE__, pid) do
    DynamicSupervisor.terminate_child(supervisor, pid)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
