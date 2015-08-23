defmodule Apiv3.CameraControllerTest do
  use Apiv3.SessionConnCase
 
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "index", %{conn: conn, account: account} do
    path = conn |> camera_path(:index)
    response = conn
    |> get(path, %{})
    |> json_response(200)

    cameras = response["cameras"]
    assert Enum.count(cameras) == 0
    Enum.map cameras, fn camera -> 
      assert camera["account_id"] == account.id
    end
  end
end