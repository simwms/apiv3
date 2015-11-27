defmodule Apiv3.Plugs.UserSession do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]
  import Apiv3.UserSessionHelper

  def init(options), do: options

  def call(conn, _opts) do
    case conn |> has_user_session? do
      {true, _user} -> 
        conn 
      {false, _} ->
        conn
        |> put_status(:forbidden)
        |> render(Apiv3.ErrorView, "forbidden.json", msg: "jh user session not present uh-oh")
        |> halt
    end
  end

end