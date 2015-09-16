defmodule Apiv3.EmployeeController do
  use Apiv3.Web, :controller

  alias Apiv3.EmployeeQuery, as: Q
  alias Apiv3.Employee

  plug :scrub_params, "employee" when action in [:create, :update]
  @preload_fields Q.preload_fields
  use Apiv3.AutomagicControllerConvention, only: [:update, :delete]
  
  def index(conn, params) do
    employees = params 
    |> Q.index(conn |> current_account)
    |> Repo.all

    render(conn, "index.json", employees: employees)
  end

  def show(conn, %{"id" => id}) do
    account = conn |> current_account
    employee = cond do
      id |> Fox.StringExt.integer? -> Repo.get!(Employee, id)
      true -> Repo.get_by!(Employee, email: id, account_id: account.id)
    end 
    if employee.account_id == account.id do
      show(conn, %{model: employee})
    else
      conn
      |> put_status(:forbidden)
      |> render(Apiv3.ErrorView, "forbidden.json", msg: "employee #{employee.id} is not associated with this account")
      |> halt
    end
  end

  def show(conn, %{model: employee}) do
    employee = employee |> Repo.preload(@preload_fields)
    conn |> render("show.json", employee: employee)
  end
end
