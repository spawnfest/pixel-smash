defmodule PixelSmash.Battles.Action do
  import Algae

  alias PixelSmash.Battles

  # Just placeholder actions for now
  defsum do
    defdata Attack do
      fighter :: Battles.Fighter.t()
      target :: Battles.Fighter.t()
      damage :: integer()
    end

    defdata Cast do
      fighter :: Battles.Fighter.t()
      target :: Battles.Fighter.t()
      damage :: integer()
      spell_name :: String.t()
    end
  end
end
