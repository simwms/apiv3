defmodule Apiv3.EmployeeControllerTest do
  use Apiv3.SessionConnCase
 
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "index", %{conn: conn, account: account} do
    path = conn |> employee_path(:index)
    response = conn
    |> get(path, %{})
    |> json_response(200)

    employees = response["employees"]
    assert Enum.count(employees) == 0
    Enum.map employees, fn employee -> 
      assert employee["account_id"] == account.id
    end
  end
end