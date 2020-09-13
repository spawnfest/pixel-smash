defmodule PixelSmash.Gladiators.Gladiator do
  import Algae

  alias PixelSmash.Gladiators.Gladiator

  @type id :: String.t()

  defdata do
    id :: id()
    elo :: non_neg_integer()
    wins :: non_neg_integer()
    losses :: non_neg_integer()
    draws :: non_neg_integer()
    name :: String.t()
    data :: list()
    sprite :: map()
    max_health :: non_neg_integer()
    defense :: non_neg_integer()
    strength :: non_neg_integer()
    speed :: non_neg_integer()
    magic :: non_neg_integer()
    secret :: non_neg_integer()
    spells :: [String.t()]
    slot1 :: map()
    slot2 :: map()
  end

  def generate() do
    number_of_attrs = Enum.random(2..4)

    available_attrs =
      PixelSmash.Attributes.all()
      |> Enum.shuffle()
      |> Enum.take(number_of_attrs)

    data =
      PixelSmash.Grids.generate(5, 10, fn _, _ ->
        Enum.random(available_attrs)
      end)

    data = PixelSmash.Grids.mirror(data)
    flat_data = Enum.flat_map(data, fn x -> x end)

    gladiator = %Gladiator{
      id: Ecto.UUID.generate(),
      elo: 1500,
      wins: 0,
      losses: 0,
      draws: 0,
      data: data,
      sprite: %PixelSmash.Sprites.Sprite{},
      name: Faker.Person.En.name(),
      max_health: 50 + count_entries(flat_data, :vitality),
      defense: 10 + count_entries(flat_data, :defense),
      strength: 3 + count_entries(flat_data, :strength),
      magic: 8 + count_entries(flat_data, :casting),
      speed: 1 + count_entries(flat_data, :speed),
      secret: 0 + count_entries(flat_data, :secret),
      spells: Faker.Util.sample_uniq(3, &Faker.Superhero.En.power/0)
    }

    sprite = PixelSmash.Sprites.Spritifier.to_sprite(gladiator)
    Map.put(gladiator, :sprite, sprite)
  end

  defp count_entries(list, entry) do
    list
    |> Enum.filter(fn x -> x == entry end)
    |> Enum.count()
  end
end
