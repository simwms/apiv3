defmodule Apiv3.Repo.Migrations.CreatePaymentSubscription do
  use Ecto.Migration

  def change do
    create table(:payment_subscriptions) do
      add :stripe_subscription_id, :string
      add :stripe_token, :string
      add :token_already_consumed, :boolean, default: false
      add :service_plan_id, :integer
      add :account_id, :integer

      timestamps
    end
    create index(:payment_subscriptions, [:service_plan_id])
    create index(:payment_subscriptions, [:account_id])
  end
end
