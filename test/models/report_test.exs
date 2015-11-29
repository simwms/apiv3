defmodule Apiv3.ReportTest do
  use Apiv3.ModelCase
  alias Apiv3.Report
  alias Timex.DateFormat
  alias Timex.Date
  test "createset-hashify-signature-match" do
    date = Date.local
    account = %{id: 3234}
    params = %{
      "start_at" => DateFormat.format!(date, "{ISO}"),
      "finish_at" => DateFormat.format!(date, "{ISO}")
    }
    {:ok, report} = Report.createset(account, params) |> Report.hashify
    assert report[:id]
    assert report[:start_at]
    assert report[:finish_at]
    assert report[:account_id] == 3234

  end
end