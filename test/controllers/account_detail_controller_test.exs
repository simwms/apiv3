defmodule Apiv3.AccountDetailControllerTest do
  use Apiv3.SessionConnCase

  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "show", %{conn: conn, account: account} do
    path = conn |> account_detail_path(:show, account.permalink)
    response = conn
    |> get(path, [])
    |> json_response(200)

    detail = response["account_detail"]

    employee = Apiv3.Employee |> Repo.get!(detail["employee_id"])

    service_plan = account |> assoc(:service_plan) |> Repo.one!
    assert detail["id"] == account.id
    assert detail["service_plan_id"] == service_plan.id
    assert employee.account_id == account.id
    assert detail["employees"] == 1
    assert detail["docks"] == 1
    assert detail["warehouses"] == 1
    assert detail["scales"] == 1
  end
end