defmodule Apiv3.CameraView do
  use Apiv3.Web, :view

  def render("show.json", %{camera: camera}) do
    %{camera: render_one(camera, "camera.json")}
  end

  def render("index.json", %{cameras: cameras}) do
    %{cameras: render_many(cameras, "camera.json")}
  end

  def render("camera.json", %{camera: camera}) do
    dictify camera
  end

  def dictify(camera) do
    %{
      id: camera.id,
      permalink: camera.permalink,
      camera_name: camera.camera_name,
      mac_address: camera.mac_address,
      created_at: camera.inserted_at,
      updated_at: camera.updated_at,
      camera_style: camera.camera_style,
      tile_id: camera.tile_id
    }
    |> Apiv3.TileView.reject_blank_keys
  end

end
