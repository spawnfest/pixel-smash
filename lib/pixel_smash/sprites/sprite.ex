defmodule PixelSmash.Sprites.Sprite do
  @moduledoc """
  Helpers for working with sprite structures.
  """

  @derive Jason.Encoder
  defstruct [
    :x,
    :y,
    :map
  ]

  require Logger

  @type t() :: %__MODULE__{}
  @type coor() :: {integer(), integer()}

  @default_size 10

  def default_size, do: @default_size

  @doc """
  Creates a sprite nesting list of pixels into sprite.
  """
  def new(pixels) when length(pixels) == @default_size * @default_size do
    size = @default_size
    data = Enum.chunk_every(pixels, size)
    map = to_map(data, size, size)
    %__MODULE__{x: size, y: size, map: map}
  end

  @doc """
  Creates a X by Y sprite with with all starting values being `:nil`. A generator function may
  be applied in order to fill the sprite with the desired data.

  No matter the generation fuction, sprites are always mirrored in the y-vertical axis.
  """
  @spec new(x :: pos_integer(), y :: pos_integer(), generator_fn :: (() -> term())) :: t()
  def new(size_x, size_y, generator_fn \\ &nils/0) do
    %__MODULE__{x: size_x, y: size_y}
    |> generate(generator_fn)
  end

  @doc """
  Applies a "mask" over the first sprite argument. By default the original sprite will be overritten
  by the mask mask but it is possible to pass a merge function to decide between values.

  If the mask "overflows" the original sprite it will be cut from the end result.
  """
  @spec apply_mask(
          sprite :: t(),
          mask :: t(),
          merge_fn :: (key :: any(), value1 :: any(), value2 :: any() -> any())
        ) :: t()
  def apply_mask(%__MODULE__{} = sprite, %__MODULE__{} = mask, merge_fn \\ &merge/3) do
    mask_map =
      mask.map
      |> Enum.reject(fn {{x, y}, _value} -> x > sprite.x or y > sprite.y end)
      |> Enum.reject(fn {{x, y}, _value} -> x < 1 or y < 1 end)
      |> Enum.into(%{})

    map = Map.merge(sprite.map, mask_map, merge_fn)
    Map.put(sprite, :map, map)
  end

  @doc """
  Modifies the original position of any sprite by applying a sum to the original coordinates.
  The sum here is considered boundless positive or negative values.
  """
  @spec position(sprite :: t(), at :: coor()) :: t()
  def position(%__MODULE__{} = sprite, at \\ {0, 0}) do
    map =
      Enum.map(sprite.map, fn {key, value} ->
        key = add_coordinate(key, at)
        {key, value}
      end)

    Map.put(sprite, :map, map)
  end

  defp generate(%__MODULE__{} = sprite, generator_fn) do
    # Generates a list of lists according to the generator function
    data =
      for _ <- 1..sprite.y do
        generate_row(sprite.x, generator_fn)
      end

    map = to_map(data, sprite.x, sprite.y)

    Map.put(sprite, :map, map)
  end

  defp to_map(data, x_size, y_size) do
    coordinates =
      for y <- 1..y_size, x <- 1..x_size do
        {x, y}
      end

    # Finally we flatten the original list of lists
    elements = Enum.flat_map(data, fn x -> x end)

    Enum.zip(coordinates, elements) |> Enum.into(%{})
  end

  @spec generate_row(size :: integer(), (() -> term())) :: list()
  defp generate_row(size, generator_fn) do
    # Generates half a row.
    half = div(size, 2)
    x1_row = Enum.map(1..half, fn _x -> generator_fn.() end)

    # Mirrors it.
    x2_row = Enum.reverse(x1_row)

    # And finally merges it with its other half.
    if even?(size) do
      Enum.concat(x1_row, x2_row)
    else
      Enum.concat([x1_row, [generator_fn.()], x2_row])
    end
  end

  @spec add_coordinate(coor_a :: coor(), coor_b :: coor()) :: coor()
  defp add_coordinate(coor_a, coor_b) do
    # Adds a pair of coordinate tuples {x, y} + {x', y'}
    {xa, ya} = coor_a
    {xb, yb} = coor_b

    {xa + xb, ya + yb}
  end

  # Default anonymous function for the `apply_mask` function
  defp merge(_key, _value1, value2), do: value2

  # Default anonymous function for the `new` function
  defp nils(), do: nil

  @spec even?(value :: integer()) :: boolean()
  defp even?(value) do
    rem(value, 2) == 0
  end

  # Print helper for debugger, should use the stdout Protocol
  def ins(%__MODULE__{} = sprite) do
    for y <- 1..sprite.y do
      row =
        for x <- 1..sprite.x do
          sprite.map[{x, y}]
        end

      row = Enum.join(row, "\t")
      Logger.info(inspect(row))
    end
  end
end
