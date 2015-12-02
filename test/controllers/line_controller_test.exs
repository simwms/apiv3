defmodule Apiv3.LineControllerTest do
  use Apiv3.SessionConnCase

  @line_attr %{
    "line_type" => "road",
    "x" => 8,
    "y" => 81,
    "points" => "12,33 11,77 0,0",
    "line_name" => "Percy Pennyworth"
  }
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "it should properly create", %{conn: conn, account: account} do
    path = conn |> line_path(:create)
    response = conn
    |> post(path, line: @line_attr)
    |> json_response(201)

    %{ "data" => line } = response
    assert line["id"]
    assert line["type"] == "lines"

    attrs = line["attributes"]
    assert attrs["x"] == "8"
    assert attrs["y"] == "81"
    assert attrs["points"] == @line_attr["points"]
    assert attrs["line_name"] == "Percy Pennyworth"
    assert attrs["line_type"] == "road"

    id = account.id
    assert %{"data" => %{"id" => ^id, "type" => "accounts"}} = line["relationships"]["account"]
  end
end