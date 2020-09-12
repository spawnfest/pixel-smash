defmodule PixelSmash.Gladiators do
  import Ecto.Query, warn: false
  alias PixelSmash.Repo
  alias PixelSmash.Gladiators.Gladiator

  def generate_gladiator do
    [
      name: random_name(),
      exhaustion: random_exhaustion(),
      health: random_health(),
      strength: random_strength(),
      speed: random_speed(),
      magic: random_magic(),
      spells: random_spells()
    ]
    |> Gladiator.new()
    |> Gladiator.populate_sprite()
    |> Gladiator.verify_fields!()
  end

  defp random_name, do: Faker.Person.En.name()
  defp random_exhaustion, do: Enum.random(60..90)
  defp random_health, do: Enum.random(50..100)
  defp random_strength, do: Enum.random(10..30)
  defp random_speed, do: Enum.random(5..25)
  defp random_magic, do: Enum.random(15..45)

  defp random_spells do
    num = Enum.random(1..3)

    1..num
    |> Enum.to_list()
    |> Enum.map(fn _index -> Faker.Superhero.En.power end)
    |> Enum.uniq()
  end

  defdelegate build_fighter(gladiator), to: Gladiator

  def persist_gladiator(name, sprite) do
    %Gladiator{}
    |> Gladiator.gladiator_changeset(%{name: name, sprite: sprite})
    |> Repo.insert()
  end

  def get_gladiator!(id) do
    Gladiator
    |> Repo.get!(id)
    |> Gladiator.populate_attributes()
    |> Gladiator.verify_fields!()
  end
end
