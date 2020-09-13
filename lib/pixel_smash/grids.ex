defmodule PixelSmash.Grids do
  @moduledoc """
  Helpers to generate different kinds of matrix structures.
  """

  @type grid_data() :: list(list())
  @type grid_map() :: %{{integer(), integer()} => term()}
  @type size() :: pos_integer()

  @doc """
  Generates a X by Y (list of lists) with all starting values being `:nil`. A generator function
  may be applied in order to fill the sprite with the desired data.
  """
  @spec generate(size_x :: size(), size_y :: size(), generator_fn :: (size(), size() -> term())) ::
          grid_data()
  def generate(size_x, size_y, generator_fn \\ fn _x, _y -> nil end) do
    for y <- 1..size_y do
      for x <- 1..size_x do
        generator_fn.(x, y)
      end
    end
  end

  @doc """
  Transforms a list of list into a map representation.
  """
  @spec to_map(data :: grid_data(), size_x :: size(), size_y :: size()) :: grid_map()
  def to_map(data, size_x, size_y) do
    coordinates =
      for y <- 1..size_y, x <- 1..size_x do
        {x, y}
      end

    elements = Enum.flat_map(data, fn x -> x end)
    Enum.zip(coordinates, elements) |> Enum.into(%{})
  end

  def mirror(data) do
    Enum.map(data, fn row ->
      reverse = Enum.reverse(row)
      Enum.concat(row, reverse)
    end)
  end
end
