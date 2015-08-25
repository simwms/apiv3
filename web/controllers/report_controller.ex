defmodule Apiv3.ReportController do
  use Apiv3.Web, :controller
  alias Apiv3.ReportQuery
  def index(conn, params) do
    account = conn |> current_account
    appointments = params |> ReportQuery.appointments(account) |> Repo.all
    assigns = [
      start_at: params["start_at"],
      finish_at: params["finish_at"],
      appointments: appointments
    ]
    conn
    |> Phoenix.Controller.put_layout("print.html")
    |> render("index.html", assigns)
  end
end