defmodule PixelSmash.Gladiators.SpriteMapper do
  @moduledoc """
  Module to map Gladiator attributes to Sprite Pixels and vice versa.

  ## Examples

      iex> alias PixelSmash.Gladiators.SpriteMapper
      ...> alias PixelSmash.Sprites.Sprite
      iex> attributes = [exhaustion: 50, health: 100, strength: 10, speed: 60, magic: 80]
      ...> %Sprite{data: [row1 | _]} = SpriteMapper.sprite(attributes)
      ...> [{:black, 50}, {:green, 100}, {:red, 10}, {:purple, 60}, {:blue, 80} | _] = row1
  """

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

    Sprites.new_pixel(base_color, value)
  end

  def attributes(%Sprite{map: map} = sprite) do

  end
end
