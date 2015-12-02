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

    hash = response["data"]
    id = employee.id
    assert %{"id" => ^id, "type" => "employees", "attributes" => attrs, "relationships" => rels} = hash
    
    assert attrs["email"] == employee.email
    assert attrs["role"] == "admin_manager"
    assert rels["account"]["data"]["id"] == account.id
  end
end