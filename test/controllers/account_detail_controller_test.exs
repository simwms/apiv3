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

    detail = response["data"]
    relationships = detail["relationships"]
    
    assert %{"data" => %{"id" => id, "type" => "employees"}} = relationships["employee"]
    employee = Apiv3.Employee |> Repo.get!(id)

    assert employee.account_id == account.id

    service_plan = account |> assoc(:service_plan) |> Repo.one!
    assert detail["id"] == account.permalink
    assert detail["type"] == "account_details"

    attrs = detail["attributes"]
    assert attrs["employees"] == 1
    assert attrs["docks"] == 1
    assert attrs["warehouses"] == 4
    assert attrs["scales"] == 1

    id = service_plan.id
    assert %{"data" => %{ "id" => ^id, "type" => "service_plans" } } = relationships["service_plan"]
  end
end