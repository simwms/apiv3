defmodule Apiv3.Repo.Migrations.CreateAppointmentRelationships do
  use Ecto.Migration

  def change do
    create table(:appointment_relationships) do
      add :pickup_id, :integer
      add :dropoff_id, :integer
      add :notes, :string
      add :account_id, :integer, null: false
      timestamps
    end
    create index(:appointment_relationships, [:account_id])
    create index(:appointment_relationships, [:pickup_id, :dropoff_id], unique: true)
    create index(:appointment_relationships, [:dropoff_id, :pickup_id], unique: true)
  end
end
