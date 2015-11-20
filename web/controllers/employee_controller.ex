defmodule Apiv3.EmployeeController do
  use Apiv3.Web, :controller

  alias Apiv3.EmployeeQuery, as: Q

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
    employee = conn 
    |> current_account
    |> assoc(:employees)
    |> Repo.get!(id)

    show(conn, %{model: employee})
  end

  def show(conn, %{model: employee}) do
    employee = employee |> Repo.preload(@preload_fields)
    conn |> render("show.json", employee: employee)
  end
end
