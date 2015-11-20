defmodule Apiv3.Repo.Migrations.AddDeletedAtToAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :deleted_at, :datetime
    end
  end
end
