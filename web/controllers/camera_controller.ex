defmodule Apiv3.CameraController do
  use Apiv3.Web, :controller
  plug Apiv3.Plugs.ScrubParamsChoice, ["data", "camera"] when action in [:create, :update]

  @preload_fields []
  use Apiv3.AutomagicControllerConvention

  def index(conn, _) do
    cameras = conn
    |> current_account
    |> assoc(:cameras)
    |> Repo.all
    render conn, "index.json", cameras: cameras
  end

end
