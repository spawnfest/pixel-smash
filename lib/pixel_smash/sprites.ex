defmodule PixelSmash.Sprites do
  alias PixelSmash.Sprites.{
    Pixel,
    Sprite
  }

  def generate_sprite(size) do
    Sprite.new(size)
  end

  def new_sprite(pixels) do
    count = Sprite.default_size() * Sprite.default_size() - length(pixels)
    fitting_pixels = pixels ++ Pixel.background(count)
    Sprite.new(fitting_pixels)
  end

  defdelegate new_pixel(base_color, tint), to: Pixel, as: :new
end
