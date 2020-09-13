defmodule PixelSmash.Battles.Battle do
  import Algae

  alias PixelSmash.Battles.{
    Action,
    ActionPropertiesDeck,
    Battle,
    Fighter,
    Log
  }

  @type id :: String.t()

  defsum do
    defdata Scheduled do
      id :: Battle.id()
      fighters :: {Fighter.t(), Fighter.t()} \\ nil
    end

    defdata InProgress do
      id :: Battle.id()
      fighters :: {Fighter.t(), Fighter.t()} \\ nil
      log :: Log.t()
    end

    defdata Finished do
      id :: Battle.id()
      fighters :: {Fighter.t(), Fighter.t()} \\ nil
      outcome :: :left | :draw | :right
      log :: Log.t()
    end
  end

  def schedule(%Fighter{} = left, %Fighter{} = right) do
    left = %{left | all_actions_properties: ActionPropertiesDeck.actions_properties(left)}
    right = %{right | all_actions_properties: ActionPropertiesDeck.actions_properties(right)}

    Battle.Scheduled.new(Ecto.UUID.generate(), {left, right})
  end

  def start(%Battle.Scheduled{} = battle) do
    Battle.InProgress.new(battle.id, battle.fighters)
  end

  def narrate(%Battle.InProgress{} = battle) do
    Log.narrate(battle.log)
  end

  def narrate(%Battle.Finished{} = battle) do
    Log.narrate(battle.log)
  end

  def simulate(%Battle.InProgress{} = battle) do
    case simulate_tick(battle) do
      %Battle.InProgress{} = battle ->
        simulate(battle)

      %Battle.Finished{} = battle ->
        battle
    end
  end

  def simulate_tick(%Battle.InProgress{} = battle) do
    battle =
      case choose_fighter(battle) do
        :none ->
          battle

        :left ->
          {fighter, opponent} = battle.fighters
          {fighter, opponent, action} = take_turn(fighter, opponent)

          %Battle.InProgress{battle | fighters: {fighter, opponent}}
          |> log_action(action)

        :right ->
          {opponent, fighter} = battle.fighters
          {fighter, opponent, action} = take_turn(fighter, opponent)

          %Battle.InProgress{battle | fighters: {opponent, fighter}}
          |> log_action(action)
      end

    battle
    |> map_fighters(&Fighter.rest/1)
    |> check_if_finished()
  end

  def choose_fighter(%Battle.InProgress{} = battle) do
    {left, right} = battle.fighters

    case {left.exhaustion, right.exhaustion} do
      {n, _} when n <= 0 -> :left
      {_, n} when n <= 0 -> :right
      {_, _} -> :none
    end
  end

  def take_turn(%Fighter{} = fighter, %Fighter{} = opponent) do
    {action, fighter} = next_action(fighter, opponent)
    {fighter, opponent} = Action.apply(action, fighter, opponent)
    fighter = apply_exhaustion(fighter, action)

    {fighter, opponent, action}
  end

  defp next_action(%Fighter{} = fighter, %Fighter{} = opponent) do
    {properties, fighter} = Fighter.next_action_properties(fighter)
    {action_from_properties(properties, fighter, opponent), fighter}
  end

  defp action_from_properties(properties, fighter, opponent) do
    case properties.kind do
      :cast ->
        %Action.Cast{
          fighter: fighter,
          target: opponent,
          damage: properties.damage,
          spell_name: properties.spell_name
        }

      :attack ->
        %Action.Attack{
          fighter: fighter,
          target: opponent,
          damage: properties.damage
        }
    end
  end

  def apply_exhaustion(%Fighter{} = fighter, action) do
    cost = Action.energy_cost(action)

    %Fighter{fighter | exhaustion: fighter.exhaustion + cost}
  end

  def check_if_finished(%Battle.InProgress{fighters: {left, right}} = battle) do
    case {left.health, right.health} do
      {n, _} when n <= 0 ->
        %Battle.Finished{
          id: battle.id,
          fighters: battle.fighters,
          outcome: :right,
          log: battle.log
        }

      {_, n} when n <= 0 ->
        %Battle.Finished{
          id: battle.id,
          fighters: battle.fighters,
          outcome: :left,
          log: battle.log
        }

      _ ->
        battle
    end
  end

  defp map_fighters(%Battle.InProgress{fighters: {left, right}} = battle, fun) do
    %Battle.InProgress{battle | fighters: {fun.(left), fun.(right)}}
  end

  defp log_action(%Battle.InProgress{log: log} = battle, action) do
    %Battle.InProgress{battle | log: Log.append(log, action)}
  end
end
