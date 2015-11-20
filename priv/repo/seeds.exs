# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Apiv3.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seeds do
  alias Apiv3.ServicePlan
  alias Apiv3.Repo
  alias Apiv3.ServicePlanHarmonizer
  def plant do
    seed_service_plans
  end

  @test_plan %{
    "presentation" => "Test",
    "stripe_plan_id" => "test-seed",
    "version" => "seed",
    "description" => "Test plan, should not be visible for selection",
    "deprecated_at" => Timex.Date.local,
    "monthly_price" => 0
  }
  
  @basic_plan %{
    "presentation" => "Small Business",
    "stripe_plan_id" => "basic-seed",
    "version" => "seed",
    "description" => "Basic plan is ideal for small warehouses with low traffic.",
    "monthly_price" => 5000,
    "docks" => 5,
    "scales" => 2,
    "warehouses" => 36,
    "users" => 10,
    "availability" => 24,
    "employees" => 10,
    "appointments" => 25
  }
  @standard_plan %{
    "presentation" => "Average Medium",
    "stripe_plan_id" => "standard-seed",
    "version" => "seed",
    "description" => "Standard plan for medium sized warehouses with high traffic.",
    "monthly_price" => 10000,
    "docks" => 10,
    "users" => 25,
    "availability" => 24,
    "employees" => 25,
    "appointments" => 75
  }
  @enterprise_plan %{
    "presentation" => "Large Enterprise",
    "stripe_plan_id" => "enterprise-seed",
    "version" => "seed",
    "description" => "Enterprise plan for large enterprise warehouses, no hard limits on anything.",
    "monthly_price" => 20000,
    "availability" => 24
  }
  @seed_plans [@test_plan, @basic_plan, @standard_plan, @enterprise_plan]
  defp seed_service_plans do
    @seed_plans
    |> Enum.map(&seed_service_plan/1)
  end
  defp seed_service_plan(seed) do
    seed
    |> find_or_create!
    |> ServicePlanHarmonizer.synchronize_stripe
  end

  def find_or_create!(seed) do
    %{"stripe_plan_id" => id} = seed
    case ServicePlan |> Repo.get_by(stripe_plan_id: id) do
      nil ->
        %ServicePlan{}
        |> ServicePlan.changeset(seed)
        |> Repo.insert!
      plan -> plan
    end
  end

end
Seeds.plant