defmodule PixelSmash.Gladiators.Grid do
  @moduledoc """
  Helpers for working with grid structures.
  """

  defstruct [
    :x,
    :y,
    :map
  ]

  require Logger

  @type t() :: %__MODULE__{}
  @type coor() :: {integer(), integer()}

  @doc """
  Creates a X by Y grid with with all starting values being `:nil`. A generator function may
  be applied in order to fill the grid with the desired data.

  No matter the generation fuction, grids are always mirrored in the y-vertical axis.
  """
  @spec new(x :: pos_integer(), y :: pos_integer(), generator_fn :: (() -> term())) :: t()
  def new(size_x, size_y, generator_fn \\ &nils/0) do
    %__MODULE__{x: size_x, y: size_y}
    |> generate(generator_fn)
  end

  @doc """
  Applies a "mask" over the first grid argument. By default the original grid will be overritten
  by the mask but it is possible to pass a merge function to decide between values.

  If the mask "overflows" the original grid it will be cut from the end result.
  """
  @spec apply_mask(
          grid :: t(),
          mask :: t(),
          merge_fn :: (key :: any(), value1 :: any(), value2 :: any() -> any())
        ) :: t()
  def apply_mask(%__MODULE__{} = grid, %__MODULE__{} = mask, merge_fn \\ &merge/3) do
    mask_map =
      mask.map
      |> Enum.reject(fn {{x, y}, _value} -> x > grid.x or y > grid.y end)
      |> Enum.reject(fn {{x, y}, _value} -> x < 1 or y < 1 end)
      |> Enum.into(%{})

    map = Map.merge(grid.map, mask_map, merge_fn)
    Map.put(grid, :map, map)
  end

  @doc """
  Modifies the original position of any grid by applying a sum to the original coordinates.
  The sum here is considered boundless positive or negative values.
  """
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
    # Generates a list of lists according to the generator function
    data =
      for _ <- 1..grid.y do
        generate_row(grid.x, generator_fn)
      end

    # Creates a list of coordinates of the specified grid size
    coordinates =
      for y <- 1..grid.y, x <- 1..grid.x do
        {x, y}
      end

    # Finally we flatten the original list of lists
    elements = Enum.flat_map(data, fn x -> x end)

    # And merge it with coordinates to create our "map"
    map = Enum.zip(coordinates, elements) |> Enum.into(%{})
    Map.put(grid, :map, map)
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
