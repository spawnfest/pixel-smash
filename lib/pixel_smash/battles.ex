defmodule PixelSmash.Battles do
  alias PixelSmash.Battles.{
    Fighter,
    Server,
    Supervisor
  }

  defdelegate child_spec(init_arg), to: Supervisor

  def schedule_battle(%Fighter{} = left, %Fighter{} = right) do
    DynamicSupervisor.start_child(PixelSmash.Battles.DynamicSupervisor, {Server, {left, right}})
  end

  def start_battle(battle_server) do
    Server.start_battle(battle_server)
  end

  def narrate_battle(battle_server) do
    Server.get_narration(battle_server)
  end
end
