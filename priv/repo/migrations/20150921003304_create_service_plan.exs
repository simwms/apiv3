defmodule Apiv3.Repo.Migrations.CreateServicePlan do
  use Ecto.Migration

  def change do
    create table(:service_plans) do
      add :service_plan_id, :string
      add :docks, :integer
      add :employees, :integer
      add :warehouses, :integer
      add :scales, :integer
      add :account_id, :integer
      add :simwms_name, :string

      timestamps
    end
    create index(:service_plans, [:account_id], unique: true)
  end
end
