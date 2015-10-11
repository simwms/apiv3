defmodule Apiv3.ServicePlanHarmonizer do
  alias Apiv3.Repo
  alias Apiv3.ServicePlan
  @moduledoc """
  Harmonizers are used in synchronize local database data with
  remote services, case in point: Stripe

  Outside of tests, one should use these things only in the context
  of warp jobs via the Apiv3.Stargate
  """
  def harmonize(service_plan) do
    fn ->
      service_plan |> synchronize_stripe
    end
  end

  def synchronize_stripe(service_plan) do
    if service_plan.synced_with_stripe, do: service_plan, else: initialize_stripe(service_plan)
  end

  defp initialize_stripe(service_plan) do
    {:ok, _stripe_plan} = find_or_create_stripe_plan service_plan

    service_plan
    |> ServicePlan.changeset(%{"synced_with_stripe" => true})
    |> Repo.update!
  end

  defp find_or_create_stripe_plan(service_plan) do
    case service_plan.stripe_plan_id |> Stripex.Plans.retrieve do
      {:error, %{status_code: 404}} -> 
        Stripex.Plans.create id: service_plan.stripe_plan_id,
          amount: service_plan.monthly_price,
          currency: "usd",
          name: service_plan.presentation,
          interval: "month",
          statement_descriptor: "simwms cloud service"
      {:ok, plan} -> {:ok, plan}
    end
  end
end