defmodule Apiv3.ReportController do
  use Apiv3.Web, :controller
  alias Apiv3.ReportQuery
  def index(conn, params) do
    appointments = params |> ReportQuery.appointments |> Repo.all
    batches = params |> ReportQuery.batches |> Repo.all
    assigns = [
      start_at: params["start_at"],
      finish_at: params["finish_at"],
      appointments: appointments,
      batches: batches
    ]
    conn
    |> Phoenix.Controller.put_layout("print.html")
    |> render("index.html", assigns)
  end
end