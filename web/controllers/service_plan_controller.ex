defmodule Apiv3.ServicePlanController do
  use Apiv3.Web, :controller

  alias Apiv3.ServicePlan
  alias Apiv3.ServicePlanHarmonizer
  alias Apiv3.Stargate
  def show(conn, %{"id" => id}) do
    service_plan = ServicePlan |> Repo.get!(id)
    conn
    |> render("show.json", service_plan: service_plan)
  end

  def index(conn, %{"show" => "all"}) do
    plans = ServicePlan |> Repo.all

    conn
    |> render("index.json", service_plans: plans)
  end
  def index(conn, _) do
    query = from s in ServicePlan,
      where: is_nil(s.deprecated_at),
      order_by: [desc: s.id],
      limit: 4
    plans = query |> Repo.all
    conn
    |> render("index.json", service_plans: plans)
  end

  def harmonize(plan) do
    plan 
    |> ServicePlanHarmonizer.harmonize
    |> Stargate.warp_sync
    plan
  end

  def create(conn, %{"service_plan" => params}) do
    changeset = ServicePlan.changeset(%ServicePlan{}, params)

    case Repo.insert(changeset) do
      {:ok, plan} ->
        conn
        |> put_status(:created)
        |> render("show.json", service_plan: harmonize(plan))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "service_plan" => params}) do
    plan = ServicePlan |> Repo.get!(id)
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

  def delete(conn, %{"id" => id}) do
    plan = Repo.get!(ServicePlan, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(plan)

    send_resp(conn, :no_content, "")
  end
end