defmodule Apiv3.UserEmployeeControllerTest do
  use Apiv3.SessionConnCase

  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "show by id", %{conn: conn, account: account} do
    [employee] = account 
    |> assoc(:employees)
    |> Repo.all
  
    path = conn |> user_employee_path(:show, employee.id)
    response = conn
    |> get(path, %{})
    |> json_response(200)

    hash = response["employee"]
    assert hash["id"] == employee.id
    assert hash["email"] == employee.email
    assert hash["account_id"] == account.id
    assert hash["role"] == "admin_manager"
  end
end