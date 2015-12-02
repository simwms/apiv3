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
    |> json_response(201)

    point = response["data"]
    assert point["id"]

    attrs = point["attributes"]
    assert attrs["x"] == "8"
    assert attrs["y"] == "81"
    assert attrs["point_name"] == "Percy Pennyworth"
    assert attrs["point_type"] == "road"

    assert point["relationships"]["account"]["data"]["id"] == account.id
  end
end