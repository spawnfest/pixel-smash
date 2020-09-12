defmodule PixelSmash.Gladiators do
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
    1..3
    |> Enum.map(fn _ -> Enum.random(["Freeze Ray", "Fireball", "Gazebo"]) end)
    |> Enum.uniq()
  end

  defdelegate build_fighter(gladiator), to: Gladiator
end
