defmodule PixelSmash.Repo do
  use Ecto.Repo,
    otp_app: :pixel_smash,
    adapter: Ecto.Adapters.Postgres

  alias PixelSmash.Sprites.Sprite

  def sprite_from_map(map) when is_map(map) do
    map
    |> Enum.reduce(%Sprite{}, fn {key, value}, sprite ->
      Map.put(sprite, String.to_existing_atom(key), value)
    end)
    |> Map.update!(:map, &map_to_coordinates_and_colors(&1))
  end

  def map_to_coordinates_and_colors(map) do
    Enum.reduce(map, %{}, fn {key, value}, map ->
      Map.put(map, coordinates_string_to_tuple(key), color_list_to_tuple(value))
    end)
  end

  defp coordinates_string_to_tuple(binary) do
    binary
    |> String.to_charlist()
    |> List.to_tuple()
  end

  defp color_list_to_tuple(list) do
    {name, tint} = List.to_tuple(list)
    {String.to_existing_atom(name), tint}
  end
end

defmodule TupleEncoder do
  alias Jason.Encoder

  defimpl Encoder, for: Tuple do
    def encode(data, options) when is_tuple(data) do
      data
      |> Tuple.to_list()
      |> Encoder.List.encode(options)
    end
  end

  defimpl String.Chars, for: Tuple do
    def to_string(data) when is_tuple(data) do
      data
      |> Tuple.to_list()
      |> List.to_string()
    end
  end
end
