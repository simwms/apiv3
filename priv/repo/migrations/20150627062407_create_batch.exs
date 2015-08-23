defmodule Apiv3.Repo.Migrations.CreateBatch do
  use Ecto.Migration

  def change do
    create table(:batches) do
      add :outgoing_count, :integer, default: 0, null: false
      add :permalink, :string
      add :description, :string
      add :quantity, :string
      add :deleted_at, :datetime
      add :dock_id, :integer
      add :appointment_id, :integer
      add :warehouse_id, :integer
      add :truck_id, :integer

      add :account_id, :integer, null: false
      timestamps
    end
    create index(:batches, [:account_id])
    create index(:batches, [:dock_id])
    create index(:batches, [:appointment_id])
    create index(:batches, [:warehouse_id])
    create index(:batches, [:truck_id])
  end

end
