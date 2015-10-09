defmodule Apiv3.Repo.Migrations.ModifyServicePlans do
  use Ecto.Migration

  def change do
    alter table(:service_plans) do
      add :stripe_plan_id, :string
      add :monthly_price, :integer, default: 0
      add :description, :string
      add :presentation, :string
    end
    create index(:service_plans, [:stripe_plan_id])
  end
end
