defmodule Apiv3.ReportControllerTest do
  use Apiv3.SessionConnCase
 
  setup do
    {account, conn} = account_session_conn()
    conn = conn
    |> put_req_header("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
    {:ok, conn: conn, account: account}
  end
  
  test "index", %{conn: conn, account: account} do
    path = conn |> report_path(:index)
    response = conn
    |> get(path, %{})
    |> html_response(200)

    assert response =~ "Appointment Summary"
  end
end