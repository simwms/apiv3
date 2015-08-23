defmodule Apiv3.Repo.Migrations.CreateTile do
  use Ecto.Migration

  def change do
    create table(:tiles) do
      add :tile_type, :string
      add :tile_name, :string
      add :status, :string
      add :x, :integer
      add :y, :integer
      add :z, :integer
      add :width, :decimal, precision: 10, scale: 6
      add :height, :decimal, precision: 10, scale: 6
      add :deleted_at, :datetime
      add :capacity, :integer

      add :account_id, :integer, null: false
      timestamps
    end
    create index(:tiles, [:account_id])
  end
end
