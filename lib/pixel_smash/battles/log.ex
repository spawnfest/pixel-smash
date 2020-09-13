defmodule PixelSmash.Battles.Log do
  import Algae

  alias PixelSmash.Battles

  defdata do
    actions :: [Battles.Actions.t()] \\ []
    narrations :: [String.t()] \\ []
  end

  def narrate(%Battles.Log{narrations: narrations}) do
    narrations
  end

  def append(%Battles.Log{} = log, action) do
    %Battles.Log{log
    | actions: log.actions ++ [action],
      narrations: log.narrations ++ [narrate_action(action)]}
  end

  defp narrate_action(%Battles.Action.Attack{} = action) do
    attack_narration(Enum.random(1..3), action)
  end

  defp narrate_action(%Battles.Action.Cast{} = action) do
    cast_narration(Enum.random(1..3), action)
  end

  defp attack_narration(1, action) do
    [
    action.fighter.name,
    " leaps into action and hits ",
    action.target.name,
    " for ",
    Integer.to_string(action.damage),
    " damage!"
    ]
  end

  defp attack_narration(2, action) do
    [
    action.fighter.name,
    " attacks and does ",
    Integer.to_string(action.damage),
    " damage to ",
    action.target.name,
    "."
    ]
  end

  defp attack_narration(3, action) do
    [
      action.fighter.name,
      " tirelessly strikes ",
      action.target.name,
      " with ",
      Integer.to_string(action.damage),
      " damage."
    ]
  end

  defp cast_narration(1, action) do
    [
      action.fighter.name,
      " conjures up ",
      action.spell_name,
      " and flings it at ",
      action.target.name,
      " for ",
      Integer.to_string(action.damage),
      " damage!"
    ]
  end

  defp cast_narration(2, action) do
    [
      action.fighter.name,
      " calls the force of ",
      action.spell_name,
      " and does ",
      Integer.to_string(action.damage),
      " damage to ",
      action.target.name,
      ".",
    ]
  end

  defp cast_narration(3, action) do
    [
      action.fighter.name,
      " ventures a spell of the ",
      action.spell_name,
      " on ",
      action.target.name,
      " with ",
      Integer.to_string(action.damage),
      " damage."
    ]
  end
end
