defmodule PixelSmash.Gladiators.SpriteMapper do
  @moduledoc """
  Module to map Gladiator attributes to Sprite Pixels and vice versa.

  ## Examples

  It can map list of attributes to a Sprite.
  Attribute with zero value maps to backgound color.

      iex> alias PixelSmash.{Gladiators.SpriteMapper, Sprites.Sprite}
      ...> attributes = [exhaustion: 0, exhaustion: 50, health: 100, strength: 10, speed: 60, magic: 80]
      ...> %Sprite{map: map} = SpriteMapper.sprite(attributes)
      ...> %{{1, 1} => {:gray, 100}, {2, 1} => {:black, 50}, {3, 1} => {:green, 100}, {4, 1} => {:red, 10}, {5, 1} => {:purple, 60}, {6, 1} => {:blue, 80}} = map

  And map a Sprite to list of attributes.
  Last found Pixel's tint value maps to appropriate attribute value.

      iex> alias PixelSmash.{Gladiators.SpriteMapper, Sprites}
      ...> sprite = Sprites.new_sprite([{:black, 40}, {:black, 50}, {:green, 100}, {:red, 10}, {:purple, 60}, {:blue, 80}, {:gray, 100}])
      ...> attributes = SpriteMapper.attributes(sprite)
      ...> [exhaustion: 50, health: 100, strength: 10, speed: 60, magic: 80] = attributes
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

  defp pixel({_key, 0}), do: Sprites.background_pixel()

  defp pixel({key, value}) do
    base_color =
      Enum.find_value(@attribute_base_color, fn
        {^key, color} -> color
        _ -> nil
      end)

    Sprites.new_pixel(base_color, value)
  end

  def attributes(%Sprite{map: map, x: size_x}) do
    base_colors = Enum.map(@attribute_base_color, &elem(&1, 1))

    map
    |> Enum.into([])
    |> Enum.sort(fn {{x1, y1}, _}, {{x2, y2}, _} -> x1 + y1 * size_x <= x2 + y2 * size_x end)
    |> Enum.map(fn {_coords, value} -> value end)
    |> Enum.filter(fn {color, _tint} -> color in base_colors end)
    |> Enum.reduce([], &put_attribute(&2, &1))
    |> Enum.reverse()
  end

  defp put_attribute(acc, {_base_color, tint} = color) do
    Keyword.put(acc, find_attribute(color), tint)
  end

  def find_attribute({base_color, _tint}) do
    Enum.find_value(@attribute_base_color, fn
      {attribute, ^base_color} -> attribute
      _ -> nil
    end)
  end
end
