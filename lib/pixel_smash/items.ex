defmodule PixelSmash.Items do
  alias PixelSmash.Items.Pattern

  def build(%Pattern{} = pattern) do
    pattern
    |> randomize()
  end

  def double_build(%Pattern{} = pattern) do
    pattern
    |> randomize()
    |> duplicate()
  end

  defp randomize(%Pattern{} = pattern) do
    # Randomizes all `"?"` characters from a template
    data =
      Enum.map(pattern.data, fn row ->
        Enum.map(row, fn rule ->
          if rule == "?" do
            Enum.random([" ", "X"])
          else
            rule
          end
        end)
      end)

    Map.put(pattern, :data, data)
  end

  defp duplicate(%Pattern{} = pattern) do
    # Mirror data and adjust sizes
    data =
      Enum.map(pattern.data, fn row ->
        reverse = Enum.reverse(row)
        Enum.concat(row, reverse)
      end)

    pattern
    |> Map.put(:data, data)
    |> Map.put(:x, pattern.x * 2)
    |> Map.put(:y, pattern.y * 2)
  end
end
