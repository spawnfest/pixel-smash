defmodule PixelSmash.Battles.Action do
  import Algae

  alias PixelSmash.Battles.{
    Action,
    Fighter
  }

  # Just placeholder actions for now
  defsum do
    defdata Attack do
      fighter :: Fighter.t()
      target :: Fighter.t()
      damage :: integer()
    end

    defdata Cast do
      fighter :: Fighter.t()
      target :: Fighter.t()
      damage :: integer()
      spell_name :: String.t()
    end
  end

  def energy_cost(%Action.Attack{}), do: 7
  def energy_cost(%Action.Cast{}), do: 11

  def apply(%Action.Attack{} = action, %Fighter{} = fighter, %Fighter{} = opponent) do
    result = %Fighter{
      action.target
      | health: max(0, action.target.health - action.damage)
    }

    case action.target do
      ^fighter -> {result, opponent}
      ^opponent -> {fighter, result}
    end
  end

  def apply(%Action.Cast{} = action, %Fighter{} = fighter, %Fighter{} = opponent) do
    result = %Fighter{
      action.target
      | health: max(0, action.target.health - action.damage)
    }

    case action.target do
      ^fighter -> {result, opponent}
      ^opponent -> {fighter, result}
    end
  end

  def from_properties(properties, fighter, opponent) when is_map(properties) do
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
end
