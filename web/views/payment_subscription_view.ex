defmodule Apiv3.PaymentSubscriptionView do
  use Apiv3.Web, :view
  import Fox.DictExt, only: [reject_blank_keys: 1]

  def render("index.json", %{payment_subscriptions: payment_subscriptions}) do
    %{payment_subscriptions: render_many(payment_subscriptions, __MODULE__, "payment_subscription.json")}
  end

  def render("show.json", %{payment_subscription: payment_subscription}) do
    %{payment_subscription: render_one(payment_subscription, __MODULE__, "payment_subscription.json")}
  end

  def render("payment_subscription.json", %{payment_subscription: payment_subscription}) do
    payment_subscription |> ember_attributes |> reject_blank_keys
  end

  def ember_attributes(sub) do
    %{
      id: sub.id,
      user_id: sub.account.user.id,
      account_id: sub.account_id,
      service_plan_id: sub.service_plan_id,
      inserted_at: sub.inserted_at,
      updated_at: sub.updated_at,
      token_already_consumed: sub.token_already_consumed,
      is_synced: sub.token_already_consumed }
  end
end