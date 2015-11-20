defmodule Apiv3.Repo.Migrations.CreatePoint do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :account_id, :integer
      add :x, :decimal, precision: 10, scale: 6
      add :y, :decimal, precision: 10, scale: 6
      add :a, :decimal, precision: 10, scale: 6
      add :point_type, :string
      add :point_name, :string
      timestamps
    end
    create index(:points, [:account_id])
  end
end
