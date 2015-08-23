defmodule Apiv3.Repo.Migrations.CreatePicture do
  use Ecto.Migration

  @picture_tables ~w(weighticket_pictures batch_pictures employee_pictures)a
  def change do
    @picture_tables
    |> Enum.map(&change_picture_table_for/1)
  end

  defp change_picture_table_for(name) do
    create table(name) do
      add :assoc_id, :integer
      add :location, :string
      add :etag, :string
      add :key, :string
      add :account_id, :integer, null: false
      timestamps
    end
    create index(name, [:account_id])
    create index(name, [:assoc_id])
  end
end
