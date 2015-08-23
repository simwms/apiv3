defmodule Apiv3.AccountControllerTest do
  use Apiv3.ConnCase
  alias Apiv3.Repo
  alias Apiv3.Account
  alias Apiv3.AccountBuilder
  @master_key Application.get_env(:simwms, :master_key)
  @account_attr %{
    "service_plan_id" => "test",
    "timezone" => "Americas/Los_Angeles",
    "email" => "test@test.test",
    "access_key_id" => "666hailsatan",
    "secret_access_key" => "ikitsu you na planetarium",
    "region" => "Japan"
  }
  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "it should forbid requests without the master key", %{conn: conn} do
    path = account_path(conn, :create)
    assert path == "/internal/accounts"
    response = conn 
    |> post(path, %{})
    |> json_response(403)
    assert response == %{"error" => "not authorized"}
  end

  test "it should successfully create accounts", %{conn: conn} do
    response = conn
    |> put_req_header("simwms-master-key", @master_key)
    |> post(account_path(conn, :create), account: @account_attr)
    |> json_response(200)
    account = response["account"]
    assert account["id"]
    assert account["permalink"]
    assert account["service_plan_id"] == @account_attr["service_plan_id"]
    assert account["timezone"] == @account_attr["timezone"]
    assert account["email"] == @account_attr["email"]
    assert account["access_key_id"] == @account_attr["access_key_id"]
    assert account["secret_access_key"] == @account_attr["secret_access_key"]
    assert account["region"] == @account_attr["region"]
  end

  test "after logging in, it should properly show the resource", %{conn: conn} do
    {account, _} = %Account{} |> Account.changeset(@account_attr) |> AccountBuilder.build!
    response = conn
    |> put_req_header("simwms-account-session", account.permalink)
    |> get(my_account_path(conn, :show))
    |> json_response(200)
    acct = response["account"]
    assert acct
    assert acct["id"] == account.id
  end

  test "it should reject users without the account header", %{conn: conn} do
    response = conn
    |> get(my_account_path(conn, :show))
    |> json_response(403)
    assert response == %{"error" => "not authorized"}
  end
end