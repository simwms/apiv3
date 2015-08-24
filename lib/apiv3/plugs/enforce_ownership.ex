defmodule Apiv3.Plugs.EnforceOwnership do
  import Plug.Conn
  import Apiv3.AccountSessionHelper
  import Phoenix.Controller, only: [render: 4, action_name: 1]
  def init([actions: actions]=opts) when is_list(actions) do
    actions
  end
  def init(_), do: []

  def call(conn, actions) do
    conn |> enforce_ownership(actions)
  end

  def enforce_ownership(conn, actions) do
    action = conn |> action_name
    if action in actions, do: enforce_ownership(conn), else: conn
  end
  defp enforce_ownership(conn) do
    %{account_id: account_id} = Map.get(conn.params, "model")
    %{id: id} = conn |> current_account
    if account_id == id do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(Apiv3.ErrorView, "forbidden.json", msg: "not yours")
      |> halt
    end
  end
end