defmodule Apiv3.LineController do
  use Apiv3.Web, :controller

  @preload_fields []  
  use Apiv3.AutomagicControllerConvention

  def index(conn, _params) do
    account = conn |> current_account
    lines = account
    |> assoc(:lines)
    |> Repo.all
    render(conn, "index.json", lines: lines)
  end
end