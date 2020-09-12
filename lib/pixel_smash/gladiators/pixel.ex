defmodule PixelSmash.Gladiators.Pixel do
  @moduledoc """
  Helpers for working with pixel generation.
  """

  @colors ~w(black green blue yellow red purple pink)a

  @doc """
  Randomly selects a color from a discrete set defined
  at the module level
  """
  def new() do
    Enum.random(@colors)
  end
end
