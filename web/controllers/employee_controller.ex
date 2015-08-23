defmodule Apiv3.EmployeeController do
  use Apiv3.Web, :controller

  alias Apiv3.Employee
  alias Apiv3.EmployeeQuery, as: Q
  plug :scrub_params, "employee" when action in [:create, :update]
  
  def index(conn, params) do
    employees = params |> Q.index |> Repo.all
    render(conn, "index.json", employees: employees)
  end

  def show(conn, %{"id" => id}) do
    employee = Repo.get!(Employee, id) |> Repo.preload(Q.preload_fields)
    render conn, "show.json", employee: employee
  end

  def create(conn, %{"employee" => employee_params}) do
    changeset = Employee.changeset(%Employee{}, employee_params)

    if changeset.valid? do
      employee = Repo.insert!(changeset) |> Repo.preload(Q.preload_fields)
      render(conn, "show.json", employee: employee)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "employee" => employee_params}) do
    employee = Repo.get!(Employee, id)
    changeset = Employee.changeset(employee, employee_params)

    if changeset.valid? do
      employee = Repo.update!(changeset) |> Repo.preload(Q.preload_fields)
      render(conn, "show.json", employee: employee)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    employee = Repo.get!(Employee, id)

    employee = Repo.delete!(employee) |> Repo.preload(Q.preload_fields)
    render(conn, "show.json", employee: employee)
  end
end
