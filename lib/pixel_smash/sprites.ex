defmodule PixelSmash.Sprites do
  alias PixelSmash.Sprites.Sprite

  def generate_sprite(size \\ 10) do
    Sprite.new(size)
  end
end
