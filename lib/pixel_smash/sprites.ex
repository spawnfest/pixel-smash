defmodule PixelSmash.Sprites do
  alias PixelSmash.Sprites.{
    Pixel,
    Sprite
  }

  defdelegate generate_sprite(size_x, size_y, generator_fn), to: Sprite, as: :new

  def new_sprite(pixels) do
    count = Sprite.default_size() * Sprite.default_size() - length(pixels)
    fitting_pixels = pixels ++ Pixel.background(count)
    Sprite.new(fitting_pixels)
  end

  defdelegate new_pixel, to: Pixel, as: :new
  defdelegate new_pixel(base_color, tint), to: Pixel, as: :new

  def background_pixel, do: 1 |> Pixel.background() |> List.first()
end
