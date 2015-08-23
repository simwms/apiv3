defmodule Apiv3.Plugs.AccountSession do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]
  import Apiv3.AccountSessionHelper

  def init(options), do: options

  def call(conn, _opts) do
    case conn |> has_account_session? do
      {true, account} -> 
        conn 
        |> affirm_account_session!(account)
      {false, _} ->
        conn
        |> put_status(:forbidden)
        |> render(Apiv3.ErrorView, "forbidden.json", msg: "Not logged in")
        |> halt
    end
  end
end