defmodule Apiv3.BatchControllerTest do
  use Apiv3.SessionConnCase
 
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "index", %{conn: conn, account: account} do
    path = conn |> batch_path(:index)
    response = conn
    |> get(path, %{})
    |> json_response(200)

    batches = response["data"]
    assert Enum.count(batches) == 3
    Enum.map batches, fn batch -> 
      assert batch["id"]
      assert batch["type"] == "batches"
      assert batch["relationships"]["account"]["data"]["id"] == account.id
    end
  end
end