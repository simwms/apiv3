defmodule Apiv3.Repo.Migrations.CreateWeighticket do
  use Ecto.Migration

  def change do
    create table(:weightickets) do
      add :appointment_id, :integer
      add :dock_id, :integer
      add :issuer_id, :integer
      add :finisher_id, :integer
      add :license_plate, :string
      add :notes, :text
      add :pounds, :decimal, precision: 15, scale: 2
      add :finish_pounds, :decimal, precision: 15, scale: 2
      add :external_reference, :string

      add :account_id, :integer, null: false
      timestamps
    end
    create index(:weightickets, [:account_id])
    create index(:weightickets, [:appointment_id])
    create index(:weightickets, [:dock_id])
  end
end
