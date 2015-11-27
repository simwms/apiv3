defmodule Apiv3.ReportController do
  use Apiv3.Web, :controller
  alias Apiv3.Account
  alias Apiv3.ReportQuery

  def show(conn, %{"id" => id}=params) do
    report = %{
      account_id: params["account_id"],
      start_at: params["start_at"],
      finish_at: params["finish_at"]
    }
    if id |> signature_match?(report) do
      conn 
      |> show_report_core(report)
    else
      conn
      |> put_status(:forbidden)
      |> render(Apiv3.ErrorView, "forbidden.json", msg: "report id doesn't match signature")
    end
  end

  def show_report_core(conn, params) do
    account = Account |> Repo.get!(params[:account_id])
    appointments = params |> ReportQuery.appointments(account) |> Repo.all
    assigns = params |> Enum.into(appointments: appointments)
    conn
    |> Phoenix.Controller.put_layout("print.html")
    |> render("show.html", assigns)
  end

  def create(conn, params) do
    account = conn |> current_account
    report_params = %{
      account_id: account.id,
      start_at: params["start_at"],
      finish_at: params["finish_at"]
    }
    case report_params |> make_report do
      {:ok, report} ->
        conn
        |> put_status(:created)
        |> render("show.json", report: report)
      {:error, _} -> 
        conn
        |> put_status(:unprocessable_entity)
        |> render(Apiv3.ErrorView, "forbidden.json")
    end
  end

  def signature_match?(id, report) do
    use Pipe

    case pipe_with(&just_ok/2, Poison.encode(report) |> encrypt) do
      {:ok, signature} -> id == signature
      {:error, _} -> false
    end
  end

  def make_report(params) do
    use Pipe

    pipe_with &just_ok/2,
      Poison.encode(params)
      |> encrypt
      |> recombine(params)
  end

  def just_ok({:ok, x}, f), do: f.(x)
  def just_ok(x, _), do: x

  def recombine(id, params) do
    {:ok, params |> Dict.put(:id, id)}
  end

  def encrypt(string) do
    x = :sha |> :crypto.hmac(string, master_key) |> Base.encode32
    {:ok, x}
  end

  def master_key do
    Application.get_env(:apiv3, Apiv3.Endpoint)[:simwms_master_key]
  end
end