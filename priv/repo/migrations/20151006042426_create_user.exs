defmodule Apiv3.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :password_hash, :string
      add :recovery_hash, :string
      add :remember_token, :string
      add :forget_at, :datetime
      add :remembered_at, :datetime
      add :stripe_customer_id, :string

      timestamps
    end
    create index(:users, [:email], unique: true)
    create index(:users, [:username], unique: true)
    create index(:users, [:remember_token])
    create index(:users, [:recovery_hash], unique: true)
  end
end
