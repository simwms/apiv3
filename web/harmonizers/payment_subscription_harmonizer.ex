defmodule Apiv3.PaymentSubscriptionHarmonizer do
  alias Apiv3.Repo
  alias Apiv3.PaymentSubscription
  import Ecto.Model, only: [assoc: 2]

  def harmonize(subscription) do
    fn ->
      subscription |> sync_workflow |> broadcast_success
    end
  end

  def broadcast_success(subscription) do
    user = subscription |> assoc(:user) |> Repo.one!
    user |> Apiv3.BroadcastUtils.delta(subscription)
  end

  def already_synced?(%{token_already_consumed: true}), do: true
  def already_synced?(_), do: false

  def sync_workflow(subscription) do
    if subscription |> already_synced? do
      subscription
    else
      subscription
      |> synchronize_stripe!
      |> PaymentSubscription.changeset(%{"token_already_consumed" => true})
      |> Repo.update!
    end
  end

  def synchronize_stripe!(subscription) do
    %{stripe_customer_id: cus_id} = subscription |> assoc(:user) |> Repo.one!
    params = subscription |> make_stripe_params
    case subscription.stripe_subscription_id do
      nil ->
        {:ok, stripe_subscription} = cus_id |> Stripex.Subscriptions.create(params)
        subscription
        |> PaymentSubscription.changeset(%{"stripe_subscription_id" => stripe_subscription.id})
      id ->
        {:ok, _} = {cus_id, id} |> Stripex.Subscriptions.update(params)
        subscription
    end
  end

  defp make_stripe_params(subscription) do
    %{stripe_plan_id: plan} = subscription |> assoc(:service_plan) |> Repo.one!
    metadata = %{"account_id" => subscription.account_id}
    %{plan: plan,
      source: subscription.stripe_token,
      metadata: metadata}
    |> Fox.DictExt.reject_blank_keys
  end
end