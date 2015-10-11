defmodule Apiv3.UserHarmonizerTest do
  use Apiv3.ModelCase
  import Apiv3.SeedSupport
  alias Apiv3.Stargate
  alias Apiv3.UserHarmonizer, as: H

  setup do
    {:ok, user: build_user}
  end

  test "usage", %{user: user} do
    refute user.stripe_customer_id
    user
    |> H.harmonize
    |> Stargate.warp_sync(self)

    assert_receive {:try, _}
    assert_receive {:done, %{stripe_customer_id: _}}, 1_000
  end
end