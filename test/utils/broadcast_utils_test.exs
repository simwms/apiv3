defmodule Apiv3.BroadcastUtilsTest do
  use Apiv3.ChannelCase
  alias Apiv3.UserSocket
  alias Apiv3.SeedSupport
  alias Apiv3.BroadcastUtils
  setup do
    user = SeedSupport.build_user
    {:ok, socket} = UserSocket
    |> connect(%{"user_id" => user.id})
    {:ok, socket: socket, user: user}
  end
  
  test "delta broadcast", %{user: user, socket: socket} do
    topic = "users:#{user.id}"
    @endpoint.subscribe(self(), topic)
    BroadcastUtils.delta(user, user)
    expected = %{
      id: user.id, 
      type: "users",
      attributes: %{
        email: user.email, 
        username: user.username
      }
    }
    assert socket.assigns.user_id == user.id
    assert_broadcast "delta", %{data: ^expected}
  end
end