defmodule Apiv3.Repo.Migrations.AddDeprecatedAtToServicePlan do
  use Ecto.Migration

  def change do
    alter table(:service_plans) do
      add :deprecated_at, :datetime
    end
  end
end
