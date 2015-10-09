defmodule Apiv3.PaymentSubscription do
  use Apiv3.Web, :model

  schema "payment_subscriptions" do
    field :stripe_subscription_id, :string
    field :stripe_token, :string
    field :token_already_consumed, :boolean, default: false
    belongs_to :service_plan, Apiv3.ServicePlan
    belongs_to :account, Apiv3.Account
    has_one :user, through: [:account, :user]
    timestamps
  end

  @required_fields ~w(service_plan_id account_id)
  @optional_fields ~w(stripe_subscription_id stripe_token)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def free_trial(account) do
    account
    |> Apiv3.Account.synchronize_stripe
    |> find_or_create!(Apiv3.ServicePlan.free_trial)
  end

  def find(account, plan) do
    __MODULE__ |> Repo.get_by(account_id: account.id, service_plan_id: plan.id)
  end

  def create(account, plan) do
    %__MODULE__{}
    |> changeset(%{"account_id" => account.id, "service_plan_id" => plan.id})
    |> Repo.insert!
  end

  def find_or_create!(account, plan) do
    find(account, plan) || create(account, plan)
  end

  def cancel_stripe!(subscription) do
    %{stripe_customer_id: cus_id} = subscription.account.user
    case subscription.stripe_subscription_id do
      nil -> subscription
      id -> 
        {cus_id, id} |> Stripex.Subscriptions.delete
        subscription
    end
  end

  def synchronize_stripe!(subscription) do
    synchronize_stripe!(subscription, subscription.stripe_token)
  end

  def synchronize_stripe!(subscription, source) do
    %{stripe_customer_id: cus_id} = subscription.account.user
    params = subscription |> make_stripe_params(source)
    case subscription.stripe_subscription_id do
      nil ->
        {:ok, stripe_subscription} = cus_id |> Stripex.Subscriptions.create(params)
        subscription
        |> changeset(%{"stripe_subscription_id" => stripe_subscription.id})
        |> Repo.update!
      id ->
        {:ok, _} = {cus_id, id} |> Stripex.Subscriptions.update(params)
        subscription
    end
  end

  defp make_stripe_params(subscription, source) do
    %{stripe_plan_id: plan} = subscription.service_plan |> Apiv3.ServicePlan.synchronize_stripe
    metadata = %{"account_id" => subscription.account_id}
    %{plan: plan, source: source, metadata: metadata}
  end
end
