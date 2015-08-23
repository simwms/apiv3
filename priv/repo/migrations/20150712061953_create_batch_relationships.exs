defmodule Apiv3.Repo.Migrations.CreateBatchRelationships do
  use Ecto.Migration

  def change do
    create table(:batch_relationships) do
      add :appointment_id, :integer
      add :batch_id, :integer
      add :notes, :string
      add :account_id, :integer, null: false
      timestamps
    end
    create index(:batch_relationships, [:account_id])
    create index(:batch_relationships, [:appointment_id, :batch_id], unique: true)
    create index(:batch_relationships, [:batch_id, :appointment_id], unique: true)
  end
end
