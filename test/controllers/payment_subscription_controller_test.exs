defmodule Apiv3.PaymentSubscriptionControllerTest do
  use Apiv3.SessionConnCase
  alias Apiv3.Repo
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "show", %{conn: conn, account: account} do
    path = conn |> payment_subscription_path(:show)
    %{"payment_subscription" => sub} = conn
    |> get(path, %{})
    |> json_response(200)

    plan = account |> assoc(:service_plan) |> Repo.one!

    assert sub
    assert sub["id"]
    assert sub["token_already_consumed"] == false
    assert sub["account_id"] == account.id
    assert sub["service_plan_id"] == plan.id
    assert plan.simwms_name =~ "free"
  end

  test "update", %{conn: conn, account: account} do
    plan = build_service_plan("some-other-free-plan")
    attr = %{"service_plan_id" => plan.id}
    account 
    |> assoc(:user) 
    |> Repo.one! 
    |> Apiv3.UserHarmonizer.synchronize_stripe

    path = conn |> payment_subscription_path(:update)

    %{"payment_subscription" => sub} = conn
    |> put(path, payment_subscription: attr)
    |> json_response(200)

    assert sub["service_plan_id"] == plan.id
  end

end