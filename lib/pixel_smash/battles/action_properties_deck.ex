defmodule PixelSmash.Battles.ActionPropertiesDeck do
  alias PixelSmash.Sprites

  # counts of colors should be >= 0
  @colors_attack_multiplier [
    {%{red: 12, pink: 5}, 3},
    {%{dark_red: 7, dark_green: 3}, 2},
    {%{red: 3}, 1}
  ]

  @colors_cast_multiplier [
    {%{purple: 12, dark_pink: 5}, 7},
    {%{dark_purple: 12, vitality: 5}, 2},
    {%{purple: 12}, 1}
  ]

  @doc """
  Generates attack and cast action properties from colors stats of given fighter's Sprite.
  Always adds one extra attack action properties set for case when there are no appropriate colors in the Sprite.
  """
  def actions_properties(fighter) do
    stats = Sprites.stats(fighter.sprite)
    properties_from_stats(stats, fighter)
  end

  defp properties_from_stats(stats, fighter) do
    {_, attack_actions} =
      Enum.reduce(@colors_attack_multiplier, {stats, []}, fn {color_count, multiplier},
                                                             {stats, actions} ->
        {stats, reductions_count} = reduce_stats(stats, color_count)
        attacks = List.duplicate(attack_action_properties(fighter, multiplier), reductions_count)
        {stats, actions ++ attacks}
      end)

    {_, cast_actions} =
      Enum.reduce(@colors_cast_multiplier, {stats, []}, fn {color_count, multiplier},
                                                           {stats, actions} ->
        {stats, reductions_count} = reduce_stats(stats, color_count)
        attacks = List.duplicate(cast_action_properties(fighter, multiplier), reductions_count)
        {stats, actions ++ attacks}
      end)

    [attack_action_properties(fighter, 1)] ++ attack_actions ++ cast_actions
  end

  defp reduce_stats(stats, color_count, reductions_count \\ 0) do
    reduced_stats =
      Enum.reduce_while(color_count, stats, fn {color, count}, stats ->
        stats_count = Map.get(stats, color, -1)

        if stats_count >= count do
          {:cont, Map.put(stats, color, stats_count - count)}
        else
          {:halt, :not_enough_count}
        end
      end)

    if reduced_stats == :not_enough_count do
      {stats, reductions_count}
    else
      reduce_stats(reduced_stats, color_count, reductions_count + 1)
    end
  end

  defp attack_action_properties(fighter, multiplier) do
    %{
      kind: :attack,
      damage: fighter.strength * multiplier
    }
  end

  defp cast_action_properties(fighter, multiplier) do
    %{
      kind: :cast,
      damage: fighter.magic * multiplier,
      spell_name: Enum.random(fighter.spells)
    }
  end
end
