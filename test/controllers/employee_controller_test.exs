defmodule Apiv3.EmployeeControllerTest do
  use Apiv3.SessionConnCase
  alias Apiv3.Employee
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
    assert Enum.count(employees) >= 0
    Enum.map employees, fn employee -> 
      assert employee["account_id"] == account.id
    end
  end

  @employee_params %{
    "email" => "whatever@rac.ism",
    "full_name" => "Jackson Mississippi"
  }
  test "show by id", %{conn: conn, account: account} do
    employee = account 
    |> build(:employees)
    |> Employee.changeset(@employee_params)
    |> Repo.insert!
    path = conn |> employee_path(:show, employee.id)
    response = conn
    |> get(path, %{})
    |> json_response(200)

    hash = response["employee"]
    assert hash["id"] == employee.id
    assert hash["email"] == employee.email
    assert hash["account_id"] == account.id
    assert hash["role"] == "none"
  end
end