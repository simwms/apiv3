defmodule Apiv3.PaymentSubscriptionControllerTest do
  use Apiv3.SessionConnCase
  alias Apiv3.Repo
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "show", %{conn: conn, account: account} do
    path = conn |> payment_subscription_path(:show)
    %{"data" => sub} = conn
    |> get(path, %{})
    |> json_response(200)

    plan = account |> assoc(:service_plan) |> Repo.one!
    assert plan.simwms_name =~ "free"

    assert sub["id"]
    assert sub["type"] == "payment_subscriptions"
    attrs = sub["attributes"]
    assert attrs["token_already_consumed"] == false

    assert %{"account" => %{"data" => yy}, "service_plan" => %{"data" => xx}} = sub["relationships"]
    assert yy["id"] == account.id
    assert xx["id"] == plan.id
  end

  test "update", %{conn: conn, account: account} do
    plan = build_service_plan("some-other-free-plan")
    attr = %{"service_plan_id" => plan.id}
    account 
    |> assoc(:user) 
    |> Repo.one! 
    |> Apiv3.UserHarmonizer.synchronize_stripe

    path = conn |> payment_subscription_path(:update)

    %{"data" => %{"relationships" => %{"service_plan" => sp}}} = conn
    |> put(path, payment_subscription: attr)
    |> json_response(200)

    assert sp["data"]["id"] == plan.id
  end

end