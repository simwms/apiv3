defmodule Apiv3.TileController do
  use Apiv3.Web, :controller
  alias Apiv3.Tile
  alias Apiv3.TileQuery
  @preload_fields TileQuery.preload_fields
  use Apiv3.AutomagicControllerConvention

  def index(conn, params) do
    account = conn |> current_account
    tiles = params 
    |> TileQuery.index(account)
    |> Repo.all
    render conn, "index.json", tiles: tiles
  end

  def create(conn, %{"tile" => tile_params}) do
    changeset = conn
    |> current_account
    |> build(:tiles)
    |> Tile.changeset(tile_params)

    if changeset.valid? do
      tile = changeset |> Repo.insert! |> Repo.preload(@preload_fields)
      render(conn, "show.json", tile: tile)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

end
