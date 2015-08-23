defmodule Apiv3.EmployeeController do
  use Apiv3.Web, :controller

  alias Apiv3.EmployeeQuery, as: Q

  plug :scrub_params, "employee" when action in [:create, :update]
  @preload_fields Q.preload_fields
  use Apiv3.AutomagicControllerConvention
  
  def index(conn, params) do
    employees = params 
    |> Q.index(conn |> current_account)
    |> Repo.all

    render(conn, "index.json", employees: employees)
  end
end
