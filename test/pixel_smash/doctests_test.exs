defmodule PixelSmash.DoctestsTest do
  use PixelSmash.DataCase

  doctest PixelSmash.Gladiators.SpriteMapper
  doctest PixelSmash.Wallets
  doctest PixelSmash.Wallets.Vault
end
