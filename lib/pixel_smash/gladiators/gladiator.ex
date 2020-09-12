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

  def gladiator_changeset(gladiator, attrs) do
    gladiator
    |> cast(attrs, [:name, :sprite])
    |> validate_required([:name, :sprite])
  end

  def populate_sprite(%__MODULE__{} = gladiator, attributes) when is_list(attributes) do
    %{gladiator | sprite: SpriteMapper.sprite(attributes)}
  end

  def populate_attributes(%__MODULE__{} = gladiator, sprite) when is_binary(sprite) do
    struct!(gladiator, SpriteMapper.attributes(sprite))
  end

  def verify_fields!(gladiator) do
  end
end
