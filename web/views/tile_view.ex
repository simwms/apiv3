defmodule Apiv3.TileView do
  use Apiv3.Web, :view

  def render("index.json", %{tiles: tiles}) do
    %{
      tiles: render_many(tiles, "tile.json"), 
      cameras: render_cameras(tiles),
      trucks: render_trucks(tiles),
      batches: render_batches(tiles)
    }
  end

  def render("show.json", %{tile: tile}) do
    %{
      tile: render_one(tile, "tile.json"),
      cameras: render_cameras([tile]),
      trucks: render_trucks([tile]),
      batches: render_batches([tile])
    }
  end

  def render("tile.json", %{tile: tile}) do
    tile 
    |> ember_attributes
    |> reject_blank_keys
  end

  def render_batches(tiles) do
    tiles
    |> Enum.flat_map(fn tile -> tile.batches end)
    |> render_many("batch.json")
  end

  def render_trucks(tiles) do
    []
    |> Enum.concat(tiles |> Enum.flat_map(fn tile -> tile.entering_trucks end))
    |> Enum.concat(tiles |> Enum.flat_map(fn tile -> tile.exiting_trucks end))
    |> Enum.concat(tiles |> Enum.flat_map(fn tile -> tile.loading_trucks end))
    |> render_many("truck.json")
  end

  def render_cameras(tiles) do
    tiles
    |> Enum.flat_map(fn tile -> tile.cameras end)
    |> render_many("camera.json")
  end


  def ember_attributes(tile) do
    %{
      id: tile.id,
      tile_type: tile.tile_type,
      tile_name: tile.tile_name,
      status: tile.status,
      a: tile.a,
      x: tile.x,
      y: tile.y,
      z: tile.z,
      width: tile.width,
      height: tile.height,
      deleted_at: tile.deleted_at,
      created_at: tile.inserted_at,
      updated_at: tile.updated_at,
      account_id: tile.account_id,
      cameras: just_ids(tile.cameras),
      batches: just_ids(tile.batches),
      entering_trucks: just_ids(tile.entering_trucks),
      exiting_trucks: just_ids(tile.exiting_trucks),
      loading_trucks: just_ids(tile.loading_trucks)
    }
  end
end
