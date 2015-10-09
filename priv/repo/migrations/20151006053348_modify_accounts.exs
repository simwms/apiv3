defmodule Apiv3.Repo.Migrations.ModifyAccounts do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :company_name, :string
      add :is_properly_setup, :boolean, default: false
      add :user_id, :integer
    end
    create index(:accounts, [:user_id])
  end

end
