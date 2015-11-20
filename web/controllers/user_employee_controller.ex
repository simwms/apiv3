defmodule Apiv3.UserEmployeeController do
  use Apiv3.Web, :controller
  alias Apiv3.EmployeeQuery, as: Q
  
  plug :scrub_params, "employee" when action in [:create, :update]
  
  plug :put_view, Apiv3.EmployeeView

  @preload_fields Q.preload_fields

  def show(conn, %{"id" => id}) do
    employee = conn 
    |> current_user
    |> assoc(:employees)
    |> Repo.get!(id)

    show(conn, %{model: employee})
  end

  def show(conn, %{model: employee}) do
    employee = employee |> Repo.preload(@preload_fields)
    conn |> render("show.json", employee: employee)
  end
end