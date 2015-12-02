defmodule Apiv3.SessionController do
  use Apiv3.Web, :controller

  alias Apiv3.UserSessionHelper, as: Session

  plug Apiv3.Plugs.ScrubParamsChoice, ["data", "session"] when action in [:create, :update]

  def show(conn, _) do
    case conn |> current_user do
      nil ->
        conn |> send_resp(:unauthorized, "apparently not signed in")
      user ->
        conn |> render("show.json", user: user)
    end
  end

  def create(conn, %{"session" => session_params}) do
    {conn, session} = conn |> Session.login!(session_params)
    if session.logged_in? do
      conn
      |> put_status(:created)
      |> render("show.json", session: session)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: session.errors)
    end
  end

  def delete(conn, _) do
    conn 
    |> Session.logout!
    |> send_resp(:no_content, "")
  end
end