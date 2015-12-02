defmodule Apiv3.WeighticketControllerTest do
  use Apiv3.SessionConnCase
 
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "index", %{conn: conn, account: _account} do
    path = conn |> weighticket_path(:index)
    assert path == "/apiz/weightickets"
    response = conn
    |> get(path, %{})
    |> json_response(200)

    weightickets = response["data"]
    assert Enum.count(weightickets) == 0
    
  end
end