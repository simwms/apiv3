defmodule Apiv3.AccountController do
  use Apiv3.Web, :controller
  alias Apiv3.Account
  alias Apiv3.AccountBuilder

  plug :scrub_params, "account" when action in [:create, :update]

  def show(conn, _params) do
    account = conn |> current_account
    render conn, "show.json", account: account
  end

  def create(conn, %{"account" => account_params}) do
    changeset = Account.changeset(%Account{}, account_params)

    if changeset.valid? do
      {account, _} = AccountBuilder.build!(changeset)
      render(conn, "show.json", account: account)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Repo.get!(Account, id)
    changeset = Account.changeset(account, account_params)

    if changeset.valid? do
      account = Repo.update!(changeset)
      render(conn, "show.json", account: account)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
