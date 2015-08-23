defmodule Apiv3.PictureController do
  use Apiv3.Web, :controller

  alias Apiv3.Picture
  alias Apiv3.PictureBuilder
  plug :scrub_params, "picture" when action in [:create, :update]

  def index(conn, _params) do
    pictures = Repo.all(Picture)
    render(conn, "index.json", pictures: pictures)
  end

  def create(conn, %{"picture" => picture_params}) do
    changeset = PictureBuilder.changeset(picture_params)

    if changeset.valid? do
      picture = Repo.insert!(changeset)
      render(conn, "show.json", picture: picture)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    picture = Repo.get!(Picture, id)
    render conn, "show.json", picture: picture
  end

  def update(conn, %{"id" => id, "picture" => picture_params}) do
    picture = Repo.get!(Picture, id)
    changeset = Picture.changeset(picture, picture_params)

    if changeset.valid? do
      picture = Repo.update!(changeset)
      render(conn, "show.json", picture: picture)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    picture = Repo.get!(Picture, id)

    picture = Repo.delete!(picture)
    render(conn, "show.json", picture: picture)
  end
end
