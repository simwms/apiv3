defmodule Apiv3.ServicePlanControllerTest do
  use Apiv3.SessionConnCase
  @master_key Application.get_env(:simwms, :master_key)

  setup do
    conn = conn() 
    |> put_req_header("accept", "application/json")
    |> put_req_header("simwms-master-key", @master_key)
    {account, _} = build_account
    {:ok, conn: conn, account: account}
  end

  @plan_params %{
    "service_plan_id" => "double trouble",
    "simwms_name" => "harold chen",
    "docks" => 4,
    "warehouses" => 44,
    "employees" => 101,
    "scales" => 99
  }

  test "update", %{conn: conn, account: account} do
    assert account.id
    path = conn |> service_plan_path(:update, account.id)
    assert path =~ ~r/\/internal\/service_plans\/\d+/
    %{"service_plan" => service_plan} = conn
    |> put(path, service_plan: @plan_params)
    |> json_response(200)

    assert service_plan["account_id"] == account.id
    assert service_plan["service_plan_id"] == @plan_params["service_plan_id"]
    assert service_plan["simwms_name"] == @plan_params["simwms_name"]
    assert service_plan["docks"] == @plan_params["docks"]
    assert service_plan["warehouses"] == @plan_params["warehouses"]
    assert service_plan["employees"] == @plan_params["employees"]
    assert service_plan["scales"] == @plan_params["scales"]
  end
end