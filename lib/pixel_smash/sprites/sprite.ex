defmodule PixelSmash.Sprites.Sprite do
  @moduledoc """
  Helpers for working with sprite structures.
  """

  defstruct [
    :x,
    :y,
    :map
  ]

  @type t() :: %__MODULE__{}
  @type coor() :: {integer(), integer()}

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
  def apply_mask(
        %__MODULE__{} = sprite,
        %__MODULE__{} = mask,
        merge_fn \\ fn _k, _v1, v2 -> v2 end
      ) do
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
  def position(%__MODULE__{} = sprite, at) do
    map =
      Enum.map(sprite.map, fn {key, value} ->
        key = add_coordinate(key, at)
        {key, value}
      end)
      |> Enum.into(%{})

    Map.put(sprite, :map, map)
  end

  @spec add_coordinate(coor_a :: coor(), coor_b :: coor()) :: coor()
  defp add_coordinate(coor_a, coor_b) do
    # Adds a pair of coordinate tuples {x, y} + {x', y'}
    {xa, ya} = coor_a
    {xb, yb} = coor_b

    {xa + xb, ya + yb}
  end

  def stats(%__MODULE__{map: map}) do
    map
    |> Map.values()
    |> Enum.frequencies()
  end
end
