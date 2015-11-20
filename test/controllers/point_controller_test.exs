defmodule Apiv3.PointControllerTest do
  use Apiv3.SessionConnCase

  @point_attr %{
    "point_type" => "road",
    "x" => 8,
    "y" => 81,
    "point_name" => "Percy Pennyworth"
  }
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "it should properly create", %{conn: conn, account: account} do
    path = conn |> point_path(:create)
    response = conn
    |> post(path, point: @point_attr)
    |> json_response(200)

    point = response["point"]
    assert point["id"]
    assert point["account_id"] == account.id
    assert point["x"] == "8"
    assert point["y"] == "81"
    assert point["point_name"] == "Percy Pennyworth"
    assert point["point_type"] == "road"
  end
end