defmodule Apiv3.AccountController do
  use Apiv3.Web, :controller
  alias Apiv3.Account
  alias Apiv3.AccountBuilder

  plug :scrub_params, "account" when action in [:create, :update]

  def show(conn, %{"id" => id}) do
    user = conn |> current_user
    query = from a in assoc(user, :accounts),
      where: a.id == ^id,
      select: a
    account = query
    |> Repo.one!
    |> Repo.preload([:service_plan])
    render conn, "show.json", account: account
  end

  def index(conn, _params) do
    accounts = conn |> current_user |> assoc(:accounts) |> Repo.all
    render conn, "index.json", accounts: accounts
  end

  def create(conn, %{"account" => account_params}) do
    params = account_params |> Dict.put("user", conn |> current_user!)
    changeset = AccountBuilder.virtual_changeset(params)

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
    account = Repo.get(Account, id) || Repo.get_by!(Account, permalink: id)
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
