defmodule Apiv3.ServicePlanControllerTest do
  use Apiv3.SessionConnCase
  alias Apiv3.ServicePlan
  @master_key Application.get_env(:simwms, :master_key)

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  @plan_params %{
    "stripe_plan_id" => "double trouble",
    "monthly_price" => 1245,
    "simwms_name" => "harold chen",
    "docks" => 4,
    "warehouses" => 44,
    "employees" => 101,
    "scales" => 99
  }

  test "create", %{conn: conn} do
    path = conn |> service_plan_path(:create)
    %{"service_plan" => plan} = conn
    |> put_req_header("simwms-master-key", @master_key)
    |> post(path, service_plan: @plan_params)
    |> json_response(201)

    assert plan["id"]
    assert plan["stripe_plan_id"] == @plan_params["stripe_plan_id"]
    assert plan["docks"] == @plan_params["docks"]
    assert plan["warehouses"] == @plan_params["warehouses"]
    assert plan["employees"] == @plan_params["employees"]
    assert plan["scales"] == @plan_params["scales"]
    assert plan["monthly_price"] == @plan_params["monthly_price"]
  end

  test "update", %{conn: conn} do
    plan = ServicePlan.changeset(%ServicePlan{}, @plan_params) |> Repo.insert!
    path = conn |> service_plan_path(:update, plan.id)
    %{"service_plan" => plan2} = conn
    |> put_req_header("simwms-master-key", @master_key)
    |> put(path, service_plan: %{"monthly_price" => 999})
    |> json_response(200)

    assert plan.id == plan2["id"]
    assert plan2["monthly_price"] == 999
  end

  test "delete", %{conn: conn} do
    plan = ServicePlan.changeset(%ServicePlan{}, @plan_params) |> Repo.insert!
    path = conn |> service_plan_path(:delete, plan.id)
    conn
    |> put_req_header("simwms-master-key", @master_key)
    |> delete(path, [])

    refute Repo.get(ServicePlan, plan.id)
  end

  test "show", %{conn: conn} do
    plan = ServicePlan.changeset(%ServicePlan{}, @plan_params) |> Repo.insert!
    path = conn |> service_plan_path(:show, plan.id)
    %{ "service_plan" => plan2 } = conn
    |> get(path, [])
    |> json_response(200)

    assert plan.id == plan2["id"]
  end

  test "index", %{conn: conn} do
    plan = ServicePlan.changeset(%ServicePlan{}, @plan_params) |> Repo.insert!
    path = conn |> service_plan_path(:index)
    %{ "service_plans" => [plan2] } = conn
    |> get(path, [])
    |> json_response(200)

    assert plan.id == plan2["id"]
  end
end