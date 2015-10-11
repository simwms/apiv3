defmodule Apiv3.ServicePlanHarmonizerTest do
  use Apiv3.ModelCase
  import Apiv3.SeedSupport
  alias Apiv3.Stargate
  alias Apiv3.ServicePlanHarmonizer, as: H

  setup do
    {:ok, plan: build_service_plan("harold-and-kumar-go-to-hell")}
  end

  test "usage", %{plan: plan} do
    assert plan.stripe_plan_id == "harold-and-kumar-go-to-hell"
    plan
    |> H.harmonize
    |> Stargate.warp_sync(self)

    assert_receive {:try, _}
    assert_receive {:done, %{synced_with_stripe: true}}, 1_000
  end
end