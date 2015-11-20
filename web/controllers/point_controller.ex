defmodule Apiv3.PointController do
  use Apiv3.Web, :controller

  @preload_fields []  
  use Apiv3.AutomagicControllerConvention

  def index(conn, _params) do
    account = conn |> current_account
    points = account
    |> assoc(:points)
    |> Repo.all
    render(conn, "index.json", points: points)
  end
end