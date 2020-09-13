defmodule PixelSmash.Battles.Fighter do
  import Algae

  alias PixelSmash.Battles.Fighter
  alias PixelSmash.Gladiators

  defdata do
    id :: String.t()
    name :: String.t()
    sprite :: map()
    exhaustion :: non_neg_integer()
    max_health :: non_neg_integer()
    health :: non_neg_integer()
    strength :: non_neg_integer()
    speed :: non_neg_integer()
    magic :: non_neg_integer()
    spells :: [String.t()]
    all_actions_properties :: [map()]
    remaining_actions_properties :: [map()]
  end

  def next_action_properties(%Fighter{} = fighter) do
    fighter = maybe_fill_remaining_actions(fighter)
    %Fighter{remaining_actions_properties: [action | actions_tail]} = fighter
    {action, %{fighter | remaining_actions_properties: actions_tail}}
  end

  defp maybe_fill_remaining_actions(%Fighter{remaining_actions_properties: []} = fighter) do
    %{fighter | remaining_actions_properties: Enum.shuffle(fighter.all_actions_properties)}
  end

  defp maybe_fill_remaining_actions(%Fighter{} = fighter), do: fighter

  def rest(%Fighter{} = fighter) do
    %Fighter{fighter | exhaustion: max(0, fighter.exhaustion - fighter.speed)}
  end

  def from_gladiator(%Gladiators.Gladiator{} = gladiator) do
    %Fighter{
      id: gladiator.id,
      name: gladiator.name,
      sprite: gladiator.sprite,
      max_health: gladiator.max_health,
      health: gladiator.max_health,
      strength: gladiator.strength,
      speed: gladiator.speed,
      magic: gladiator.magic,
      spells: gladiator.spells,
      exhaustion: 0
    }
  end
end
