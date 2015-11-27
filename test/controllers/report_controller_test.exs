defmodule Apiv3.ReportControllerTest do
  use Apiv3.SessionConnCase
  alias Timex.Date
  alias Timex.DateFormat
  alias Apiv3.ReportController
  setup do
    {account, conn} = account_session_conn()
    conn = conn
    |> put_req_header("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
    {:ok, conn: conn, account: account}
  end
  
  test "make_report" do
    params = %{
      account_id: 23423,
      start_at: "dkfjalsdf",
      finish_at: "3389308jd"
    }
    report = ReportController.make_report params
    assert {:ok, _} = report
  end

  test "create and show", %{conn: conn, account: account} do
    date = Date.local
    path = conn |> report_path(:create)
    params = %{
      "start_at" => DateFormat.format!(date, "{ISO}"),
      "finish_at" => DateFormat.format!(date, "{ISO}")
    }
    %{"report" => report} = conn
    |> post(path, params)
    |> json_response(201)

    assert report["id"] 
    assert report["account_id"] == account.id
    assert report["start_at"] == params["start_at"]
    assert report["finish_at"] == params["finish_at"]
  
    path = conn |> report_path(:show, report["id"])
    response = conn
    |> get(path, report)
    |> html_response(200)

    assert response =~ "Appointment Summary"
  end
end