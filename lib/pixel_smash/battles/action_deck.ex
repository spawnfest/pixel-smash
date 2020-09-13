defmodule PixelSmash.Battles.ActionDeck do
  alias PixelSmash.{
    Battles.Action,
    Sprites
  }

  # counts of colors should be >= 0
  @colors_attack_multiplier [
    {%{red: 12, pink: 5}, 10},
    {%{dark_red: 7, dark_green: 3}, 5},
    {%{red: 3}, 1}
  ]

  @colors_cast_multiplier [
    {%{purple: 12, dark_pink: 5}, 10},
    {%{dark_purple: 12, vitality: 5}, 2},
    {%{purple: 12}, 1}
  ]

  def deck_for_fighter(fighter, opponent) do
    stats = Sprites.stats(fighter.sprite)
    actions(stats, fighter, opponent)
  end

  def actions(stats, fighter, opponent) do
    {_, attack_actions} =
      Enum.reduce(@colors_attack_multiplier, {stats, []}, fn {color_count, multiplier},
                                                             {stats, actions} ->
        {stats, reductions_count} = reduce_stats(stats, color_count)
        attacks = List.duplicate(attack_action(fighter, opponent, multiplier), reductions_count)
        {stats, actions ++ attacks}
      end)

    {_, cast_actions} =
      Enum.reduce(@colors_cast_multiplier, {stats, []}, fn {color_count, multiplier},
                                                           {stats, actions} ->
        {stats, reductions_count} = reduce_stats(stats, color_count)
        attacks = List.duplicate(cast_action(fighter, opponent, multiplier), reductions_count)
        {stats, actions ++ attacks}
      end)

    attack_actions ++ cast_actions
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

  defp attack_action(fighter, opponent, multiplier) do
    %Action.Attack{
      fighter: fighter,
      target: opponent,
      damage: fighter.strength * multiplier
    }
  end

  defp cast_action(fighter, opponent, multiplier) do
    %Action.Cast{
      fighter: fighter,
      target: opponent,
      damage: fighter.magic * multiplier,
      spell_name: Enum.random(fighter.spells)
    }
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end
end
