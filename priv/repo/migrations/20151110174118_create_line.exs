defmodule Apiv3.Repo.Migrations.CreateLine do
  use Ecto.Migration

  def change do
    create table(:lines) do
      add :account_id, :integer
      add :line_type, :string
      add :line_name, :string
      add :x, :decimal, precision: 10, scale: 6
      add :y, :decimal, precision: 10, scale: 6
      add :a, :decimal, precision: 10, scale: 6
      add :points, :text
      timestamps
    end
    create index(:lines, [:account_id])
  end
end
