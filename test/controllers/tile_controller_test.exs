defmodule Apiv3.TileControllerTest do
  use Apiv3.SessionConnCase

  @tile_attr %{
    "tile_type" => "barn",
    "x" => 8,
    "y" => 8,
    "width" => 1.0,
    "height" => 1.0
  }
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "it should ship with 4 default tiles", %{conn: conn, account: account} do
    path = conn |> tile_path(:index)
    response = conn
    |> get(path, %{})
    |> json_response(200)

    tiles = response["tiles"]
    assert Enum.count(tiles) == 4
    Enum.map tiles, fn tile -> 
      assert tile["account_id"] == account.id
    end
  end

  test "it should properly create", %{conn: conn, account: account} do
    path = conn |> tile_path(:create)
    response = conn
    |> post(path, tile: @tile_attr)
    |> json_response(200)

    tile = response["tile"]
    assert tile["id"]
    assert tile["account_id"] == account.id
  end
end