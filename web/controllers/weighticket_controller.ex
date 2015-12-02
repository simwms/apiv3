defmodule Apiv3.WeighticketController do
  use Apiv3.Web, :controller

  alias Apiv3.WeighticketQuery, as: Q

  plug Apiv3.Plugs.ScrubParamsChoice, ["data", "weighticket"] when action in [:create, :update]
  @preload_fields Q.preload_fields
  use Apiv3.AutomagicControllerConvention

  def index(conn, _params) do
    weightickets = conn 
    |> current_account
    |> assoc(:weightickets)
    |> Repo.all
    |> Repo.preload(@preload_fields)
    
    render(conn, "index.json", weightickets: weightickets)
  end
end
