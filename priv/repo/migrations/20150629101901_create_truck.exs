defmodule Apiv3.Repo.Migrations.CreateTruck do
  use Ecto.Migration

  def change do
    create table(:trucks) do
      add :entry_scale_id, :integer
      add :exit_scale_id, :integer
      add :dock_id, :integer
      add :appointment_id, :integer
      add :weighticket_id, :integer
      add :arrived_at, :datetime
      add :departed_at, :datetime
      add :docked_at, :datetime
      add :undocked_at, :datetime
      add :deleted_at, :datetime

      add :account_id, :integer, null: false
      timestamps
    end
    create index(:trucks, [:account_id])
    create index(:trucks, [:departed_at])
  end
end
