defmodule PixelSmash.Gladiators.Gladiator do
  use Ecto.Schema
  import Ecto.Changeset

  alias PixelSmash.Gladiators.SpriteMapper

  schema "gladiators" do
    field :name, :string
    field :sprite, :binary
    field :exhaustion, :integer, virtual: true
    field :health, :integer, virtual: true
    field :strength, :integer, virtual: true
    field :speed, :integer, virtual: true
    field :magic, :integer, virtual: true
    field :spells, {:array, :string}, virtual: true

    timestamps()
  end

  def new!(fields) do
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
      |> Enum.filter(attribute?)
      |> Enum.into(%{})

    %{gladiator | sprite: SpriteMapper.sprite(attributes)}
  end

  def populate_attributes(%__MODULE__{} = gladiator, sprite) when is_binary(sprite) do
    struct!(gladiator, SpriteMapper.attributes(sprite))
  end

  def verify_fields!(%__MODULE__{} = gladiator) do
  end

  def build_fighter(%__MODULE__{} = gladiator) do
  end
end
