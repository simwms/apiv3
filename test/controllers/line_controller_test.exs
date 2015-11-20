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
    |> json_response(200)

    line = response["line"]
    assert line["id"]
    assert line["account_id"] == account.id
    assert line["x"] == "8"
    assert line["y"] == "81"
    assert line["points"] == @line_attr["points"]
    assert line["line_name"] == "Percy Pennyworth"
    assert line["line_type"] == "road"
  end
end