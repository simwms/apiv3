defmodule Apiv3.WeighticketControllerTest do
  use Apiv3.SessionConnCase
 
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "index", %{conn: conn, account: account} do
    path = conn |> weighticket_path(:index)
    assert path == "/apiv3/weightickets"
    response = conn
    |> get(path, %{})
    |> json_response(200)

    weightickets = response["weightickets"]
    assert Enum.count(weightickets) == 0
    
  end
end