defmodule PixelSmash.Gladiators.Gladiator do
  import Algae

  alias PixelSmash.Sprites

  alias PixelSmash.Gladiators.{
    Gladiator,
    SpriteMapper
  }

  @type id :: String.t()

  defdata do
    id :: id()
    elo :: non_neg_integer()
    name :: String.t()
    sprite :: map()
    max_health :: non_neg_integer()
    strength :: non_neg_integer()
    speed :: non_neg_integer()
    magic :: non_neg_integer()
    spells :: [String.t()]
  end

  def generate() do
    # Temporarily we use a random sprite. We need to hook sprites up to stats
    %Gladiator{
      id: Ecto.UUID.generate(),
      elo: 1500,
      sprite:
        Sprites.generate_sprite(10, 10, fn ->
          Enum.random([
            {:red, 100.0},
            {:blue, 100.0},
            {:yellow, 100.0},
            {:purple, 100.0},
            {:green, 100.0}
          ])
        end),
      name: Faker.Person.En.name(),
      max_health: Enum.random(50..100),
      strength: Enum.random(3..18),
      speed: Enum.random(1..5),
      magic: Enum.random(8..30),
      spells: Faker.Util.sample_uniq(3, &Faker.Superhero.En.power/0)
    }
  end

  defp populate_sprite(%Gladiator{} = gladiator) do
    attribute? = fn {key, _valu} -> key in [:exhaustion, :health, :strength, :speed, :magic] end

    attributes =
      gladiator
      |> Map.from_struct()
      |> Enum.filter(attribute?)
      |> Enum.into(%{})

    %{gladiator | sprite: SpriteMapper.sprite(attributes)}
  end

  def populate_attributes(%__MODULE__{sprite: sprite} = gladiator) when is_map(sprite) do
    struct!(gladiator, SpriteMapper.attributes(sprite))
  end
end
