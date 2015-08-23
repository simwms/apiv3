defmodule Apiv3.Repo.Migrations.CreateAppointment do
  use Ecto.Migration

  def change do
    create table(:appointments) do
      add :appointment_type, :string
      add :permalink, :string
      add :deleted_at, :datetime
      add :material_description, :string
      add :material_permalink, :string
      add :company, :string
      add :company_permalink, :string
      add :notes, :text
      add :fulfilled_at, :datetime
      add :cancelled_at, :datetime
      add :expected_at, :datetime
      add :exploded_at, :datetime
      add :external_reference, :string
      add :coupled_at, :datetime
      add :consumed_at, :datetime

      add :account_id, :integer, null: false
      timestamps
    end
    create index(:appointments, [:account_id])
    create index(:appointments, [:permalink])
  end

end
