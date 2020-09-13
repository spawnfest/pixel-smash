defmodule PixelSmash.Items do
  alias PixelSmash.Items.Item
  alias PixelSmash.Items.Pattern

  def generate() do
    [
      &Pattern.helmet/0,
      &Pattern.crown/0,
      &Pattern.hat/0,
      &Pattern.scouter/0,
      &Pattern.eyepatch/0,
      &Pattern.googles/0,
      &Pattern.unilens/0,
      &Pattern.stick/0,
      &Pattern.glove/0
    ]
    |> Enum.random()
    |> (fn f -> f.() end).()
    |> enhance_item()
    |> add_attributes()
  end

  def to_sprite(item) do
    PixelSmash.Sprites.Spritifier.to_sprite(item)
  end

  defp enhance_item(%Item{} = item) do
    # Randomize pattern
    item = bend_pattern_a_little(item)

    # Mirror if appropiate
    item =
      cond do
        item.type in [:helmet, :crown, :hat, :googles, :unilens] ->
          mirror(item)

        item.type in [:stick, :glove] ->
          mirror?(item)

        true ->
          item
      end

    # Add attribute
    item =
      cond do
        item.type in [:helmet, :hat, :googles] ->
          Map.put(item, :attribute, PixelSmash.Attributes.perseverance())

        item.type in [:crown, :eyepatch, :scouter] ->
          Map.put(item, :attribute, PixelSmash.Attributes.special())

        item.type in [:unilens, :stick, :glove] ->
          Map.put(item, :attribute, PixelSmash.Attributes.combat())

        true ->
          item
      end

    # Generate name
    name(item)
  end

  defp add_attributes(%Item{} = item) do
    # We create an array of coordinates
    coordinates =
      for y <- 1..item.y, x <- 1..item.x do
        {x, y}
      end

    # Flatten the item's list of lists
    elements =
      item.data
      |> Enum.flat_map(fn x -> x end)

    # Merge results into a map
    map =
      coordinates
      |> Enum.zip(elements)
      |> Enum.into(%{})

    # Assign attributes
    map =
      Enum.map(map, fn {key, value} ->
        case value do
          "0" -> {key, :no_operation}
          "X" -> {key, item.attribute}
          " " -> {key, :empty}
        end
      end)

    Map.put(item, :map, map)
  end

  defp bend_pattern_a_little(%Item{} = item) do
    # Randomizes all `"?"` characters from a template
    data =
      Enum.map(item.data, fn row ->
        Enum.map(row, &randomize_rule/1)
      end)

    Map.put(item, :data, data)
  end

  defp randomize_rule(rule) do
    if rule == "?" do
      Enum.random([" ", "X"])
    else
      rule
    end
  end

  defp mirror?(%Item{} = item) do
    if Enum.random([true, false]) do
      mirror(item)
    else
      item
    end
  end

  defp mirror(%Item{} = item) do
    # Mirror data and adjust sizes
    data =
      Enum.map(item.data, fn row ->
        reverse = Enum.reverse(row)
        Enum.concat(row, reverse)
      end)

    item
    |> Map.put(:data, data)
    |> Map.put(:x, item.x * 2)
    |> Map.put(:y, item.y * 2)
  end

  defp name(%Item{} = item) do
    item_name = to_string(item.type)

    epic_name =
      Enum.random([
        Faker.StarWars.character(),
        Faker.StarWars.planet(),
        Faker.Color.name(),
        Faker.Color.fancy_name(),
        Faker.Vehicle.model(),
        Faker.Superhero.power(),
        Faker.Superhero.name()
      ])

    name =
      Enum.shuffle([item_name, epic_name])
      |> Enum.join(" ")
      |> String.capitalize()

    Map.put(item, :name, name)
  end
end
