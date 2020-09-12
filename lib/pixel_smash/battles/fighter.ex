defmodule PixelSmash.Battles.Fighter do
  import Algae

  alias PixelSmash.Battles.Fighter

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
end
