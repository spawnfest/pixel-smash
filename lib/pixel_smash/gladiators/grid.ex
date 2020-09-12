defmodule PixelSmash.Gladiators.Grid do
  @moduledoc """
  Helpers for working with grid structures.
  """
  alias PixelSmash.Gladiators.Pixel

  @doc """
  Creates a 10x10 grid with pre-assigned colors, it is possible to create
  grids of different sizes by passing an integer as parameter.

  Grids are always mirrored in the y-vertical axis.
  """
  def new(size \\ 10) when is_integer(size) and size > 1 do
    Enum.map(1..size, fn _x -> half_row(size) end)
  end

  @doc """
  Generates half a row, mirrors it and merges it with its other half.
  """
  def half_row(size) do
    half = div(size, 2)
    x1_row = Enum.map(1..half, fn _x -> Pixel.new() end)
    x2_row = Enum.reverse(x1_row)

    if even?(size) do
      Enum.concat x1_row, x2_row
    else
      Enum.concat([x1_row, [Pixel.new()], x2_row])
    end
  end

  defp even?(value) do
    rem(value, 2) == 0
  end

end
