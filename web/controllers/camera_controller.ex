defmodule Apiv3.CameraController do
  use Apiv3.Web, :controller
  alias Apiv3.Camera
  plug :scrub_params, "camera" when action in [:create, :update]
  

  def show(conn, %{"id" => id}) do
    camera = Repo.get!(Camera, id)
    render conn, "show.json", camera: camera
  end

  def index(conn, _) do
    cameras = Repo.all(Camera)
    render conn, "index.json", cameras: cameras
  end

  def create(conn, %{"camera" => camera_params}) do
    changeset = Camera.changeset(%Camera{}, camera_params)

    if changeset.valid? do
      camera = Repo.insert(changeset)
      render(conn, "show.json", camera: camera)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "camera" => camera_params}) do
    camera = Repo.get!(Camera, id)
    changeset = Camera.changeset(camera, camera_params)

    if changeset.valid? do
      camera = Repo.update(changeset)
      render(conn, "show.json", camera: camera)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    camera = Repo.get!(Camera, id)

    camera = Repo.delete(camera)
    render(conn, "show.json", camera: camera)
  end
end
