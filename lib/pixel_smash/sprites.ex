defmodule PixelSmash.Sprites do
  alias PixelSmash.Sprites.{
    Pixel,
    Sprite
  }

  def generate_sprite(size) do
    Sprite.new(size)
  end

  defdelegate new_sprite(pixels), to: Sprite, as: :new
  defdelegate new_pixel(base_color, tint), to: Pixel, as: :new
end
