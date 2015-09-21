defmodule Apiv3.ServicePlanView do
  use Apiv3.Web, :view

  def render("show.json", %{service_plan: service_plan}) do
    %{service_plan: render_one(service_plan, __MODULE__, "service_plan.json")}
  end

  def render("service_plan.json", %{service_plan: service_plan}) do
    service_plan |> ember_attributes |> reject_blank_keys
  end

  def ember_attributes(plan) do
    %{ 
      id: plan.id,
      account_id: plan.account_id,
      service_plan_id: plan.service_plan_id,
      simwms_name: plan.simwms_name,
      docks: plan.docks,
      warehouses: plan.warehouses,
      employees: plan.employees,
      scales: plan.scales
    }
  end
end