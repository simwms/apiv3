defmodule Apiv3.PaymentSubscriptionHarmonizerTest do
  use Apiv3.ModelCase
  import Apiv3.SeedSupport
  alias Apiv3.Stargate
  alias Apiv3.PaymentSubscriptionHarmonizer, as: H

  setup do
    {account, _} = build_account
    {:ok, account: account}
  end

  test "sanity", %{account: account} do
    subscription = account |> assoc(:payment_subscription) |> Repo.one!
    refute subscription.stripe_token
    refute subscription.stripe_subscription_id
    refute subscription.token_already_consumed
  end

  test "sync_workflow", %{account: account} do
    user = account
    |> assoc(:user)
    |> Repo.one!
    |> Apiv3.UserHarmonizer.synchronize_stripe

    assert user.stripe_customer_id

    subscription = account 
    |> assoc(:payment_subscription) 
    |> Repo.one!
    |> H.sync_workflow

    assert subscription.stripe_subscription_id =~ "sub_"
    assert subscription.token_already_consumed
  end

  test "harmonize asynchrony", %{account: account} do
    account
    |> assoc(:user)
    |> Repo.one!
    |> Apiv3.UserHarmonizer.synchronize_stripe

    account
    |> assoc(:payment_subscription) 
    |> Repo.one!
    |> H.harmonize
    |> Stargate.warp_sync(self)

    assert_receive {:done, _}, 1_000
  end
end