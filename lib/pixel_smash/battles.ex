defmodule PixelSmash.Battles do
  alias PixelSmash.Battles.{
    Battle,
    Fighter
  }

  def create_battle(%Fighter{} = left, %Fighter{} = right) do
    Battle.InProgress.new({left, right})
  end

  def tick_battle(%Battle.InProgress{} = battle) do
    Battle.simulate_tick(battle)
  end

  def narrate_battle(%Battle.InProgress{} = battle) do
    Battle.narrate(battle)
  end

  def narrate_battle(%Battle.Finished{} = battle) do
    Battle.narrate(battle)
  end
end
