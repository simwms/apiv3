defmodule Apiv3.ServicePlanController do
  use Apiv3.Web, :controller
  alias Apiv3.Account
  alias Apiv3.ServicePlan
  def update(conn, %{"id" => id, "service_plan" => params}) do
    account = Account |> Repo.get!(id)
    plan = account |> assoc(:service_plan) |> Repo.one!
    changeset = plan |> ServicePlan.changeset(params)

    case changeset |> Repo.update do
      {:ok, service_plan} ->
        conn
        |> render("show.json", service_plan: service_plan)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end
end