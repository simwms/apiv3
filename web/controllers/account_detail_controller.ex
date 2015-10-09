defmodule Apiv3.AccountDetailController do
  use Apiv3.Web, :controller

  def show(conn, %{"id" => id}) do
    meta = conn
    |> current_user!
    |> assoc(:accounts)
    |> Repo.get!(id)
    |> metacount
    render(conn, "show.json", account_detail: meta)
  end

  def metacount(account) do
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
      service_plan_id: service_plan.id,
      employees: employees,
      docks: docks,
      warehouses: warehouses,
      scales: scales
    }
  end

end