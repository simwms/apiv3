defmodule Apiv3.ServicePlanView do
  use Apiv3.Web, :view

  @attributes ~w(stripe_plan_id
    simwms_name
    description
    presentation
    docks
    warehouses
    employees
    scales
    monthly_price
    deprecated_at)a
  use Apiv3.JsViewConvention
  # def render("show.json", %{service_plan: service_plan}) do
  #   %{data: render_one(service_plan, __MODULE__, "service_plan.json")}
  # end

  # def render("index.json", %{service_plans: service_plans}) do
  #   %{data: render_many(service_plans, __MODULE__, "service_plan.json")}
  # end

  # def render("service_plan.json", %{service_plan: service_plan}) do
  #   service_plan |> jsonapify
  # end

  # def jsonapify(plan) do
  #   %{
  #     type: "service-plans", 
  #     id: plan.id,
  #     attributes: extract_attributes(plan)
  #   }
  # end

  # def extract_attributes(plan) do
  #   plan
  #   |> Map.take(@attributes)
  #   |> reject_blank_keys
  # end
end