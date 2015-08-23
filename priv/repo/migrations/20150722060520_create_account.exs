defmodule Apiv3.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :permalink, :string, null: false
      add :service_plan_id, :string
      add :timezone, :string
      add :email, :string
      add :access_key_id, :string
      add :secret_access_key, :string
      add :region, :string
      
      timestamps
    end
    create index(:accounts, [:permalink], unique: true)
  end
end
