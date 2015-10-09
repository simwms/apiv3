defmodule Apiv3.SessionController do
  use Apiv3.Web, :controller

  alias Apiv3.UserSessionHelper, as: Session

  plug :scrub_params, "session" when action in [:create, :update]

  def create(conn, %{"session" => session_params}) do
    {conn, session} = conn |> Session.login!(session_params)
    if session.logged_in? do
      conn
      |> put_status(:created)
      |> render("show.json", session: session)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", session: session)
    end
  end

  def delete(conn, _) do
    conn = conn 
    |> Session.logout!
    |> send_resp(:no_content, "")
  end
end