defmodule Apiv3.TileController do
  use Apiv3.Web, :controller
  alias Apiv3.TileQuery

  plug :scrub_params, "tile" when action in [:create, :update]

  @preload_fields TileQuery.preload_fields
  use Apiv3.AutomagicControllerConvention

  def index(conn, params) do
    account = conn |> current_account
    tiles = params 
    |> TileQuery.index(account)
    |> Repo.all
    render conn, "index.json", tiles: tiles
  end

end
