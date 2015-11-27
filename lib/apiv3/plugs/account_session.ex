defmodule Apiv3.Plugs.AccountSession do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]
  import Apiv3.AccountSessionHelper

  def init(options), do: options

  def call(conn, _opts) do
    case conn |> has_account_session? do
      {true, account} -> 
        conn 
      {false, _} ->
        conn
        |> put_status(:forbidden)
        |> render(Apiv3.ErrorView, "forbidden.json", msg: "xx account session not present")
        |> halt
    end
  end
end