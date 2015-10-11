defmodule Apiv3.StargateTest do
  use Apiv3.ModelCase
  alias Apiv3.Repo
  alias Apiv3.Stargate
  alias Apiv3.User
  test "warp_sync" do
    core = fn ->
      1 + 2
    end
    Stargate.warp_sync(core, self)
    receive do
      {:done, x} -> assert x == 3
      {:try, f} -> assert core == f
    after
      100 ->
        refute true, "nothing received"
    end
  end

  @user_params %{
    "email" => "jackson@herald.co",
    "username" => "jackson herald",
    "password" => "password123"
  }
  test "warp_sync, with repo calls" do
    core = fn ->
      %User{} |> User.changeset(@user_params) |> Repo.insert
    end
    Stargate.warp_sync(core, self)
    
    assert_receive {:try, core}
    assert_receive {:done, {:ok, _}}, 500
  end
end