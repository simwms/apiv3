defmodule Apiv3.AccountDetailController do
  use Apiv3.Web, :controller
  alias Apiv3.Account
  @moduledoc """
  Used for retrieving metadata for an account as well as ensuring account session
  """
  def show(conn, %{"id" => permalink}) do
    account = Account |> Repo.get_by!(permalink: permalink)
    employee = conn |> current_user! |> get_employee!(account)
    
    meta = account |> metacount(employee)
    render(conn, "show.json", account_detail: meta)
  end

  def get_employee!(user, account) do
    query = from e in assoc(account, :employees),
      where: e.email == ^user.email,
      select: e
    Repo.one! query
  end

  def metacount(account, employee) do
    query = from x in assoc(account, :employees), 
      select: count(x.id)
    employees = query |> Repo.one!

    query = from x in assoc(account, :tiles),
      where: x.tile_type == "barn",
      select: count(x.id)
    docks = query |> Repo.one!

    query = from x in assoc(account, :tiles),
      where: x.tile_type == "warehouse",
      select: count(x.id)
    warehouses = query |> Repo.one!

    query = from x in assoc(account, :tiles), 
      where: x.tile_type == "scale",
      select: count(x.id)
    scales = query |> Repo.one!

    service_plan = assoc(account, :service_plan) |> Repo.one!
    %{
      id: account.id,
      account_id: account.id,
      service_plan_id: service_plan.id,
      employees: employees,
      docks: docks,
      warehouses: warehouses,
      scales: scales,
      employee: employee
    }
  end

end