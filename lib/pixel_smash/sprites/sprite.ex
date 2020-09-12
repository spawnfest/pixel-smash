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
  Creates a sprite nesting list of pixels into grid.
  """
  def new(pixels) when length(pixels) == @default_size * @default_size do
    size = @default_size
    data = Enum.chunk_every(pixels, size)
    map = to_map(data, size, size)
    %__MODULE__{x: size, y: size, map: map}
  end

  @doc """
  Creates a X by Y grid with with all starting values being `:nil`. A generator function may
  be applied in order to fill the grid with the desired data.

  No matter the generation fuction, grids are always mirrored in the y-vertical axis.
  """
  def new(size_x, size_y, generator_fn \\ &nils/0) do
    %__MODULE__{x: size_x, y: size_y}
    |> generate(generator_fn)
  end

  # @spec apply_mask(grid :: t(), mask :: t()) :: t()
  def apply_mask(%__MODULE__{} = grid, %__MODULE__{} = mask, apply_fn \\ &merge/3) do
    mask_map =
      mask.map
      |> Enum.reject(fn {{x, y}, _value} -> x > grid.x or y > grid.y end)
      |> Enum.reject(fn {{x, y}, _value} -> x < 1 or y < 1 end)
      |> Enum.into(%{})

    map = Map.merge(grid.map, mask_map, apply_fn)
    Map.put(grid, :map, map)
  end

  @spec position(grid :: t(), at :: coor()) :: t()
  def position(%__MODULE__{} = grid, at \\ {0, 0}) do
    map =
      Enum.map(grid.map, fn {key, value} ->
        key = add_coordinate(key, at)
        {key, value}
      end)

    Map.put(grid, :map, map)
  end

  defp generate(%__MODULE__{} = grid, generator_fn) do
    data =
      for _ <- 1..grid.y do
        generate_row(grid.x, generator_fn)
      end

    map = to_map(data, grid.x, grid.y)

    Map.put(grid, :map, map)
  end

  defp to_map(data, x_size, y_size) do
    coordinates =
      for y <- 1..y_size, x <- 1..x_size do
        {x, y}
      end

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

  defp merge(_key, _value1, value2), do: value2

  defp nils(), do: nil

  @spec even?(value :: integer()) :: boolean()
  defp even?(value) do
    rem(value, 2) == 0
  end

  def ins(%__MODULE__{} = grid) do
    for y <- 1..grid.y do
      row =
        for x <- 1..grid.x do
          grid.map[{x, y}]
        end

      row = Enum.join(row, "\t")
      Logger.info(inspect(row))
    end
  end
end
