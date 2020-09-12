defmodule PixelSmash.Battles.Fighter do
  import Algae

  alias PixelSmash.Battles.Fighter

  defdata do
    name :: String.t()
    exhaustion :: non_neg_integer()
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
