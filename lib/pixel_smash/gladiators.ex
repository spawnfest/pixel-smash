defmodule PixelSmash.Gladiators do
  @moduledoc """
  Gladiators context. Generates and persists Gladiator into DB.

  ## Examples

      iex> alias PixelSmash.Gladiators
      ...> import Gladiators
      ...> gladiator = generate_gladiator()
      ...> {:ok, %{id: id}} = persist_gladiator(gladiator)
      ...> loaded_gladiator = get_gladiator!(id)
      ...> gladiator == loaded_gladiator
  """

  alias PixelSmash.Gladiators.Gladiator
  alias PixelSmash.Repo

  defdelegate build_fighter(gladiator), to: Gladiator

  def get_gladiator!(id) do
    Gladiator
    |> Repo.get!(id)
    |> Map.update!(:sprite, &Repo.sprite_from_map(&1))
    |> Gladiator.populate_attributes()
    |> Gladiator.verify_fields!()
  end

  def persist_gladiator(%Gladiator{} = gladiator) do
    %Gladiator{}
    |> Gladiator.gladiator_changeset(%{name: gladiator.name, sprite: gladiator.sprite})
    |> Repo.insert()
  end

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
    |> Enum.map(fn _index -> Faker.Superhero.En.power() end)
    |> Enum.uniq()
  end
end
