defmodule PixelSmash.Sprites.Sprite do
  @moduledoc """
  Helpers for working with sprite structures.
  """

  defstruct [:x, :y, :data, :map]

  alias PixelSmash.Sprites.Pixel

  @default_size 10

  def default_size, do: @default_size

  @doc """
  Creates a sprite with random pre-assigned colors, it is possible to create
  grids of different sizes by passing an integer as parameter.

  Sprites are always mirrored in the y-vertical axis.
  """
  def new(size \\ @default_size) when is_integer(size) and size > 1 do
    data = Enum.map(1..size, fn _x -> half_row(size) end)
    map = to_map(data, size)
    %__MODULE__{x: size, y: size, data: data, map: map}
  end

  @doc """
  Creates a sprite nesting list of pixels into grid.
  """
  def new(pixels) when length(pixels) == @default_size * @default_size do
    size = @default_size
    data = Enum.chunk_every(pixels, size)
    map = to_map(data, size)
    %__MODULE__{x: size, y: size, data: data, map: map}
  end

  def apply(sprite, shape, _at \\ {0, 0}) when is_list(sprite) and is_list(shape) do
    # Brittle way of getting the sprite size
    size = Enum.count(sprite)

    # Getting the size is useful for creating a range of coordinates
    coordinates =
      for y <- 1..size, x <- 1..size do
        {y, x}
      end

    elements = Enum.flat_map(sprite, fn x -> x end)

    Enum.zip(coordinates, elements) |> Enum.into(%{})
  end

  defp to_map(sprite, size) do
    coordinates =
      for y <- 1..size, x <- 1..size do
        {y, x}
      end

    elements = Enum.flat_map(sprite, fn x -> x end)

    Enum.zip(coordinates, elements) |> Enum.into(%{})
  end

  # defp to_map(%__MODULE__{} = sprite) when sprite.x == sprite.y do
  #  coordinates =
  #    for y <- 1..sprite.y, x <- 1..sprite.y do
  #      {y, x}
  #    end

  #  elements = Enum.flat_map(sprite.data, fn x -> x end)

  #  Enum.zip(coordinates, elements) |> Enum.into(%{})
  #  Map.put(sprite, :)
  # end

  @doc """
  Generates half a row of random colored pixels,
  mirrors it and merges it with its other half.
  """
  defp half_row(size) do
    half = div(size, 2)
    x1_row = Enum.map(1..half, fn _x -> Pixel.new() end)
    x2_row = Enum.reverse(x1_row)

    if even?(size) do
      Enum.concat(x1_row, x2_row)
    else
      Enum.concat([x1_row, [Pixel.new()], x2_row])
    end
  end

  defp apply_row(size) do
  end

  defp even?(value) do
    rem(value, 2) == 0
  end
end
