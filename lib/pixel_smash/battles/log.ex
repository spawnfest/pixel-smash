defmodule PixelSmash.Battles.Log do
  import Algae

  alias PixelSmash.Battles

  defdata do
    actions :: [Battles.Actions.t()] \\ []
  end

  def append(%Battles.Log{} = log, action) do
    %Battles.Log{log | actions: log.actions ++ [action]}
  end

  def narrate(%Battles.Log{} = log) do
    Enum.map(log.actions, &narrate_action/1)
  end

  defp narrate_action(%Battles.Action.Attack{} = action) do
    [
      action.fighter.name,
      " leaps into action and hits ",
      action.target.name,
      " for ",
      Integer.to_string(action.damage),
      " damage!"
    ]
  end

  defp narrate_action(%Battles.Action.Cast{} = action) do
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
end
