defmodule PixelSmash.Battles do
  alias PixelSmash.Battles.{
    Battle,
    Fighter
  }

  def schedule_battle(%Fighter{} = left, %Fighter{} = right) do
    Battle.Scheduled.new({left, right})
  end

  def start_battle(%Battle.Scheduled{} = battle) do
    Battle.InProgress.new(battle.fighters)
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
