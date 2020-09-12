defmodule PixelSmash.Battles do
  alias PixelSmash.Battles.{
    Battle,
    Fighter,
    Server,
    Supervisor
  }

  alias PixelSmash.Gladiators

  @battle_supervisor PixelSmash.Battles.DynamicSupervisor

  defdelegate child_spec(init_arg), to: Supervisor

  def schedule_series(battle_supervisor \\ @battle_supervisor) do
    Gladiators.list_gladiators()
    |> Enum.map(&fighter_from_gladiator/1)
    |> Enum.shuffle()
    |> Enum.chunk_every(2)
    |> Enum.each(fn [left, right] -> schedule_battle(battle_supervisor, left, right) end)
  end

  def schedule_battle(
        battle_supervisor \\ @battle_supervisor,
        %Fighter{} = left,
        %Fighter{} = right
      ) do
    DynamicSupervisor.start_child(battle_supervisor, {Server, {left, right}})
  end

  def list_battles(battle_supervisor \\ @battle_supervisor) do
    list_battle_servers(battle_supervisor)
    |> Enum.map(&Server.get_battle/1)
  end

  def get_battle(battle_supervisor \\ @battle_supervisor, id) do
    {_pid, battle} = get_battle_server(battle_supervisor, id)

    battle
  end

  def start_battle(battle_supervisor \\ @battle_supervisor, %Battle.Scheduled{} = battle) do
    {pid, _} = get_battle_server(battle_supervisor, battle.id)

    Server.start_battle(pid)
  end

  def narrate_battle(battle_supervisor \\ @battle_supervisor, battle)

  def narrate_battle(battle_supervisor, %Battle.InProgress{} = battle) do
    {pid, _} = get_battle_server(battle_supervisor, battle.id)

    Server.get_narration(pid)
  end

  def narrate_battle(battle_supervisor, %Battle.Finished{} = battle) do
    {pid, _} = get_battle_server(battle_supervisor, battle.id)

    Server.get_narration(pid)
  end

  defp fighter_from_gladiator(%Gladiators.Gladiator{} = gladiator) do
    %Fighter{
      id: gladiator.id,
      name: gladiator.name,
      max_health: gladiator.max_health,
      health: gladiator.max_health,
      strength: gladiator.strength,
      speed: gladiator.speed,
      magic: gladiator.magic,
      spells: gladiator.spells,
      exhaustion: 0
    }
  end

  defp list_battle_servers(battle_supervisor) do
    DynamicSupervisor.which_children(battle_supervisor)
    |> Enum.filter(fn
      {_, pid, :worker, _} when is_pid(pid) -> true
      _ -> false
    end)
    |> Enum.map(fn {_, pid, :worker, _} -> pid end)
  end

  defp get_battle_server(battle_supervisor, id) do
    list_battle_servers(battle_supervisor)
    |> Enum.map(&{&1, Server.get_battle(&1)})
    |> Enum.find(fn {_, battle} -> battle.id == id end)
  end
end
