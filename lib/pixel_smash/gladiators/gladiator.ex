defmodule PixelSmash.Gladiators.Gladiator do
  use Ecto.Schema
  import Ecto.Changeset

  alias PixelSmash.Battles.Fighter
  alias PixelSmash.Gladiators.SpriteMapper

  schema "gladiators" do
    field :name, :string
    field :sprite, :map
    field :exhaustion, :integer, virtual: true
    field :health, :integer, virtual: true
    field :strength, :integer, virtual: true
    field :speed, :integer, virtual: true
    field :magic, :integer, virtual: true
    field :spells, {:array, :string}, virtual: true

    timestamps()
  end

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def gladiator_changeset(gladiator, attrs) do
    gladiator
    |> cast(attrs, [:name, :sprite])
    |> validate_required([:name, :sprite])
  end

  def populate_sprite(%__MODULE__{} = gladiator) do
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

  def verify_fields!(%__MODULE__{
        name: name,
        sprite: sprite,
        exhaustion: exhaustion,
        health: health,
        strength: strength,
        speed: speed,
        magic: magic,
        spells: spells
      } = gladiator)
      when byte_size(name) > 0
      when not is_nil(sprite)
      when exhaustion >= 0
      when health >= 0
      when strength >= 0
      when speed >= 0
      when magic >= 0
      when is_list(spells),
      do: gladiator

  def build_fighter(%__MODULE__{} = gladiator) do
    Fighter.new(
      gladiator.name,
      gladiator.exhaustion,
      gladiator.health,
      gladiator.strength,
      gladiator.speed,
      gladiator.magic,
      gladiator.spells
    )
  end
end
