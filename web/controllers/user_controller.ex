defmodule Apiv3.UserController do
  use Apiv3.Web, :controller
  alias Apiv3.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.createset(user_params)
    case changeset |> Repo.insert do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: harmonize(user))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp harmonize(user) do
    user
    |> Apiv3.UserHarmonizer.harmonize
    |> Apiv3.Stargate.warp_sync
    user
  end
end