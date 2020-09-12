defmodule PixelSmash.Repo.Migrations.AddGladiatorsTable do
  use Ecto.Migration

  def change do
    create table(:gladiators) do
      add :name, :string, null: false
      add :sprite, :binary, null: false
      timestamps()
    end
  end
end
