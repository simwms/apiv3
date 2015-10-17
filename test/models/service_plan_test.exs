defmodule Apiv3.ServicePlanTest do
  use Apiv3.ModelCase
  alias Apiv3.ServicePlan

  test "free trial" do
    plan = ServicePlan.free_trial

    assert plan.id
    assert plan.stripe_plan_id == "free-trial-seed"
  end
end