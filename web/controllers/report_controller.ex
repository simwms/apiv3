defmodule Apiv3.ReportController do
  use Apiv3.Web, :controller
  alias Apiv3.Account
  alias Apiv3.ReportQuery
  alias Apiv3.Report

  def show(conn, %{"id" => id}=params) do
    params
    |> Report.checkset
    |> Report.hashify
    |> case do
      {:ok, %{id: ^id}} ->
        conn
        |> show_report_core(params)
      {:ok, report} ->
        conn
        |> put_status(:forbidden)
        |> render(Apiv3.ErrorView, "forbidden.json", msg: "expected id: '#{report[:id]}' ... but yours was: '#{id}'")
      {:error, changeset} ->
        conn
        |> put_status(:forbidden)
        |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show_report_core(conn, params) do
    account = Account |> Repo.get!(params["account_id"])
    appointments = params |> ReportQuery.appointments(account) |> Repo.all
    assigns = [start_at: params["start_at"], finish_at: params["finish_at"], appointments: appointments]
    conn
    |> Phoenix.Controller.put_layout("print.html")
    |> render("show.html", assigns)
  end

  def create(conn, %{"report" => params}) do
    conn
    |> current_account
    |> Report.createset(params)
    |> Report.hashify
    |> case do
      {:ok, report} ->
        conn
        |> put_status(:created)
        |> render("show.json", report: report)
      {:error, changeset} -> 
        conn
        |> put_status(:unprocessable_entity)
        |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end
end