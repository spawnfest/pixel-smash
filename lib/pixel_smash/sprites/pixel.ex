defmodule PixelSmash.Sprites.Pixel do
  @moduledoc """
  Helpers for working with pixel generation.
  """

  @colors ~w(black green blue yellow red purple pink)a
  @background_color :gray

  @doc """
  Randomly selects a color from a discrete set defined
  at the module level
  """
  def new() do
    new(Enum.random(@colors), 100)
  end

  def new(base_color, tint) when tint in 0..100 do
    {base_color, tint}
  end

  def background(count), do: List.duplicate(new(@background_color, 100), count)
end
