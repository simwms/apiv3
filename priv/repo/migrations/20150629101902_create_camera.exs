defmodule Apiv3.Repo.Migrations.CreateCamera do
  use Ecto.Migration

  def change do
    create table(:cameras) do
      add :permalink, :string
      add :camera_name, :string
      add :mac_address, :string
      add :camera_style, :string
      add :tile_id, :integer
      add :account_id, :integer, null: false
      timestamps
    end
    create index(:cameras, [:account_id])
    create index(:cameras, [:tile_id])
  end
end
