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
    %{"data" => tiles} = conn
    |> get(path, %{})
    |> json_response(200)

    assert Enum.count(tiles) == 11
    Enum.map tiles, fn tile -> 
      assert tile["id"]
      assert tile["type"] == "tiles"
      assert tile["attributes"]["x"]
      assert tile["attributes"]["y"]
      assert tile["relationships"]["account"] == %{"data" => %{"id" => account.id, "type" => "accounts"} }
    end
  end

  test "it should properly create", %{conn: conn, account: account} do
    path = conn |> tile_path(:create)
    response = conn
    |> post(path, tile: @tile_attr)
    |> json_response(201)

    tile = response["data"]
    assert tile["id"]
    assert tile["type"] == "tiles"
    assert tile["attributes"]["x"] == to_string(@tile_attr["x"])
    assert tile["attributes"]["y"] == to_string(@tile_attr["y"])
    relationships = tile["relationships"]
    assert Enum.count(relationships) == 6
    %{"account" => account_relationship} = relationships
    assert account_relationship == %{ "data" => %{"id" => account.id, "type" => "accounts"} }
  end
end