defmodule Apiv3.Repo.Migrations.ModifyPrecisionOnTiles do
  use Ecto.Migration

  def change do
    alter table(:tiles) do
      modify :x, :decimal, precision: 10, scale: 6
      modify :y, :decimal, precision: 10, scale: 6
      add :a, :decimal, precision: 10, scale: 6
    end
  end
end
