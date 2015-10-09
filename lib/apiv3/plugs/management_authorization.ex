defmodule Apiv3.Plugs.ManagementAuthorization do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]
  import Apiv3.AccountSessionHelper, only: [current_account: 1]
  import Apiv3.UserSessionHelper, only: [current_user: 1]
  alias Apiv3.Repo
  import Ecto.Model, only: [assoc: 2]
  def init(options), do: options

  def call(conn, _opts) do
    case {current_account(conn), current_user(conn)} do
      {nil, nil} -> conn |> fail("you're not logged in at all")
      {nil, _} -> conn |> fail("you have no account session")
      {_, nil} -> conn |> fail("you have an account header, but no user session")
      {account, user} -> 
        if account |> managed_by?(user) do
          conn
        else
          conn |> fail("you do not have permission to manage this account")
        end
    end
  end

  def fail(conn, msg) do
    conn
    |> put_status(:forbidden)
    |> render(Apiv3.ErrorView, "forbidden.json", msg: msg)
    |> halt
  end

  def managed_by?(account, user) do
    user
    |> assoc(:employees)
    |> Repo.get_by(account_id: account.id)
  end
end