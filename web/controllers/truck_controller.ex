defmodule Apiv3.TruckController do
  use Apiv3.Web, :controller

  plug Apiv3.Plugs.ScrubParamsChoice, ["data", "truck"] when action in [:create, :update]

  @preload_fields [:appointment, :weighticket, :batches]
  use Apiv3.AutomagicControllerConvention

  def index(conn, params) do
    trucks = params 
    |> Apiv3.TruckQuery.index(conn |> current_account)
    |> Repo.all
    |> Repo.preload(@preload_fields)
    render(conn, "index.json", trucks: trucks)
  end

end