defmodule Apiv3.Repo.Migrations.AddAngleToTile do
  use Ecto.Migration

  def change do
    alter table(:tiles) do
      add :angle, :decimal, precision: 10, scale: 6
    end
  end
end
