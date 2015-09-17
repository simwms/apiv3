defmodule Apiv3.Repo.Migrations.AddRoleToEmployees do
  use Ecto.Migration

  def change do
    alter table(:employees) do
      add :role, :string
    end
  end
end
