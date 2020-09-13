defmodule PixelSmash.Battles do
  alias PixelSmash.Battles.{
    Battle,
    BattleServer,
    BattleSupervisor,
    Matchmaking,
    Supervisor
  }

  defdelegate child_spec(init_arg), to: Supervisor

  def list_upcoming_battles(matchmaking_server \\ Matchmaking) do
    Matchmaking.list_upcoming_battles(matchmaking_server)
  end

  def list_current_battles(matchmaking_server \\ Matchmaking) do
    Matchmaking.list_current_battles(matchmaking_server)
  end

  def list_battles(battle_supervisor \\ BattleSupervisor) do
    BattleSupervisor.list_battle_servers(battle_supervisor)
    |> Enum.map(&BattleServer.get_battle/1)
  end

  def get_battle(battle_supervisor \\ BattleSupervisor, id) do
    {_pid, battle} = BattleSupervisor.get_battle_server(battle_supervisor, id)

    battle
  end

  def start_battle(battle_supervisor \\ BattleSupervisor, %Battle.Scheduled{} = battle) do
    {pid, _} = BattleSupervisor.get_battle_server(battle_supervisor, battle.id)

    BattleServer.start_battle(pid)
  end

  def narrate_battle(battle_supervisor \\ BattleSupervisor, battle)

  def narrate_battle(battle_supervisor, %Battle.InProgress{} = battle) do
    {pid, _} = BattleSupervisor.get_battle_server(battle_supervisor, battle.id)

    BattleServer.get_narration(pid)
  end

  def narrate_battle(battle_supervisor, %Battle.Finished{} = battle) do
    {pid, _} = BattleSupervisor.get_battle_server(battle_supervisor, battle.id)

    BattleServer.get_narration(pid)
  end
end
