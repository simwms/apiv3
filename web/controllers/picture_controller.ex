defmodule Apiv3.PictureController do
  use Apiv3.Web, :controller

  alias Apiv3.PictureBuilder

  plug :scrub_params, "picture" when action in [:create, :update]
  
  def create(conn, %{"picture" => picture_params}) do
    account = conn |> current_account
    changeset = picture_params |> PictureBuilder.changeset(account)

    if changeset.valid? do
      picture = Repo.insert!(changeset)
      render(conn, "show.json", picture: picture)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
