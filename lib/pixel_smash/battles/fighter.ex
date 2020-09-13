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
  end

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
