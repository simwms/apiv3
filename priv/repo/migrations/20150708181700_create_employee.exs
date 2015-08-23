defmodule Apiv3.Repo.Migrations.CreateEmployee do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :full_name, :string
      add :title, :string
      add :tile_type, :string
      add :arrived_at, :datetime
      add :left_work_at, :datetime
      add :fired_at, :datetime
      add :phone, :string
      add :email, :string
      add :tile_id, :integer

      add :account_id, :integer, null: false
      timestamps
    end
    create index(:employees, [:tile_id])
    create index(:employees, [:account_id, :email], unique: true)
  end
end
