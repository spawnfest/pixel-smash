defmodule PixelSmash.Gladiators.Grid do
  @moduledoc """
  Helpers for working with grid structures.
  """

  defstruct [:x, :y, :data, :map]

  alias PixelSmash.Gladiators.Pixel

  @doc """
  Creates a 10x10 grid with pre-assigned colors, it is possible to create
  grids of different sizes by passing an integer as parameter.

  Grids are always mirrored in the y-vertical axis.
  """
  def new(size \\ 10) when is_integer(size) and size > 1 do
    data = Enum.map(1..size, fn _x -> half_row(size) end)
    map = to_map(data, size)
    %__MODULE__{x: size, y: size, data: data, map: map}
  end

  def apply(grid, shape, _at \\ {0, 0}) when is_list(grid) and is_list(shape) do
    # Brittle way of getting the grid size
    size = Enum.count(grid)

    # Getting the size is useful for creating a range of coordinates
    coordinates =
      for y <- 1..size, x <- 1..size do
        {y, x}
      end

    elements = Enum.flat_map(grid, fn x -> x end)

    Enum.zip(coordinates, elements) |> Enum.into(%{})
  end

  defp to_map(grid, size) do
    coordinates =
      for y <- 1..size, x <- 1..size do
        {y, x}
      end

    elements = Enum.flat_map(grid, fn x -> x end)

    Enum.zip(coordinates, elements) |> Enum.into(%{})
  end

  # defp to_map(%__MODULE__{} = grid) when grid.x == grid.y do
  #  coordinates =
  #    for y <- 1..grid.y, x <- 1..grid.y do
  #      {y, x}
  #    end

  #  elements = Enum.flat_map(grid.data, fn x -> x end)

  #  Enum.zip(coordinates, elements) |> Enum.into(%{})
  #  Map.put(grid, :)
  # end

  @doc """
  Generates half a row, mirrors it and merges it with its other half.
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
