defmodule PixelSmash.Gladiators.SpriteMapper do
  alias PixelSmash.Sprites
  alias PixelSmash.Sprites.Sprite

  @attribute_base_color [
    {:exhaustion, :black},
    {:health, :green},
    {:strength, :red},
    {:speed, :purple},
    {:magic, :blue}
  ]

  def sprite(attributes) do
    attributes
    |> Enum.map(&pixel/1)
    |> Sprites.new_sprite()
  end

  defp pixel({key, value}) do
    base_color =
      Enum.find_value(@attribute_base_color, fn
        {^key, color} -> color
        _ -> nil
      end)

    tint = div(value, 33)

    Sprites.new_pixel(base_color, tint)
  end

  def attributes(%Sprite{map: map} = sprite) do
  end
end
