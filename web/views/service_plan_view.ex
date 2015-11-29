defmodule Apiv3.ServicePlanView do
  use Apiv3.Web, :view

  @moduledoc """
  Here, we use the JSON-API view convention to render json.

  You can read more about the specs here: http://jsonapi.org/

  The macro essentially boils down to programmatically delcaring the below code.

    def render("show.json", %{service_plan: service_plan}) do
      %{data: render_one(service_plan, __MODULE__, "service_plan.json")}
    end

    def render("index.json", %{service_plans: service_plans}) do
      %{data: render_many(service_plans, __MODULE__, "service_plan.json")}
    end

    def render("service_plan.json", %{service_plan: service_plan}) do
      service_plan |> jsonapify
    end

    def jsonapify(plan) do
      %{
        type: "service-plans", 
        id: plan.id,
        attributes: extract_attributes(plan),
        relationships: []
      }
    end

    def extract_attributes(plan) do
      plan
      |> Map.take(@attributes)
      |> reject_blank_keys
    end

  Just declare all the attributes you'd like to have rendered in json with the
  module attribute @attribute, and the convention will handle the rest
  """
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
  @relationships []
  use Apiv3.JsViewConvention
end