defmodule Apiv3.AccountControllerTest do
  use Apiv3.ConnCase
  alias Apiv3.Repo
  alias Apiv3.Account
  import Apiv3.SeedSupport

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "no permission", %{conn: conn} do
    path = conn |> account_path(:index)
    response = conn
    |> get(path, [])
    |> json_response(403)

    assert response == %{"errors" => %{"msg" => "jh user session not present uh-oh"}}
  end

  @account_attr %{
    "company_name" => "Some Test Co",
    "timezone" => "Americas/Los_Angeles"
  }
  test "create", %{conn: conn} do
    user = build_user
    plan = build_service_plan
    params = @account_attr |> Dict.put("service_plan_id", plan.id)
    path = conn |> account_path(:create)
    user_conn = conn
    |> post(session_path(conn, :create), session: %{"email" => user.email, "password" => "password123"})

    account_conn = user_conn
    |> post(path, account: params)

    %{"data" => account} = account_conn
    |> json_response(200)

    assert account["id"]
  end

  test "index", %{conn: conn} do
    {account, _} = build_account
    user = account |> assoc(:user) |> Repo.one!
    path = conn |> account_path(:index)
    %{"data" => accounts} = conn
    |> post(session_path(conn, :create), session: %{"email" => user.email, "password" => "password123"})
    |> get(path, [])
    |> json_response(200)

    assert Enum.count(accounts) == 1
    [accnt] = accounts
    assert accnt["id"] == account.id
  end

  test "show", %{conn: conn} do
    {account, _} = build_account
    user = account |> assoc(:user) |> Repo.one!
    path = conn |> account_path(:show, account.id)
    %{"data" => acc} = conn
    |> post(session_path(conn, :create), session: %{"email" => user.email, "password" => "password123"})
    |> get(path, [])
    |> json_response(200)

    assert acc["id"] == account.id
    attr = acc["attributes"]
    assert attr["permalink"] == account.permalink
    assert attr["email"] == user.email
    assert attr["inserted_at"]

    rel = acc["relationships"]
    assert %{"data" => %{ "id" => _, "type" => "service_plans" } } = rel["service_plan"]
  end

  test "update", %{conn: conn} do
    {account, _} = build_account
    user = account |> assoc(:user) |> Repo.one!
    path = conn |> account_path(:update, account.id)
    %{"data" => acc} = conn
    |> post(session_path(conn, :create), session: %{"email" => user.email, "password" => "password123"})
    |> put(path, account: %{"company_name" => "Bill Engvall"})
    |> json_response(200)

    assert acc["id"] == account.id
    assert acc["attributes"]["company_name"] == "Bill Engvall"
  end

  test "delete", %{conn: conn} do
    {account, _} = build_account
    user = account |> assoc(:user) |> Repo.one!
    path = conn |> account_path(:delete, account.id)
    conn = conn
    |> post(session_path(conn, :create), session: %{"email" => user.email, "password" => "password123"})
    |> delete(path, [])

    account = Repo.get!(Account, account.id)
    assert account.deleted_at

    path = conn |> account_path(:index)
    %{"data" => accounts} = conn
    |> get(path, [])
    |> json_response(200)

    assert Enum.count(accounts) == 0
  end
end