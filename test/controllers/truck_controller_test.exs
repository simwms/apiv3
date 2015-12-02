defmodule Apiv3.TruckControllerTest do
  use Apiv3.SessionConnCase
 
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "index", %{conn: conn, account: account} do
    path = conn |> truck_path(:index)
    response = conn
    |> get(path, %{})
    |> json_response(200)

    trucks = response["data"]
    assert Enum.count(trucks) == 0
    Enum.map trucks, fn truck -> 
      assert truck["relationships"]["account"]["data"]["id"] == account.id
    end
  end
end