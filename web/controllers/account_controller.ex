defmodule Apiv3.AccountController do
  use Apiv3.Web, :controller
  alias Apiv3.Account
  alias Apiv3.AccountBuilder
  alias Apiv3.ServicePlan
  plug Apiv3.Plugs.ScrubParamsChoice, ["data", "account"] when action in [:create, :update]

  def show(conn, %{"id" => id}) do
    account = conn 
    |> current_user!
    |> assoc(:accounts) 
    |> Repo.get!(id) 
    |> preloads
    render conn, "show.json", account: account
  end

  def index(conn, _params) do
    accounts = conn 
    |> current_user! 
    |> assoc(:accounts) 
    |> query_scope
    |> Repo.all 
    |> preloads
    render conn, "index.json", accounts: accounts
  end

  def create(conn, %{"account" => account_params}) do
    params = account_params 
    |> Dict.put("user", conn |> current_user!)
    |> Dict.put_new("service_plan", ServicePlan.free_trial)

    changeset = AccountBuilder.virtual_changeset(params)

    if changeset.valid? do
      {account, _} = AccountBuilder.build!(changeset)
      render(conn, "show.json", account: preloads(account))
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
      render(conn, "show.json", account: preloads(account))
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    conn
    |> current_user!
    |> assoc(:accounts)
    |> Repo.get!(id)
    |> AccountBuilder.destroy!

    send_resp(conn, :no_content, "")
  end

  defp preloads(account), do: account |> Repo.preload([:service_plan, :user])
  defp query_scope(source) do
    from a in source,
      where: is_nil(a.deleted_at)
  end
end
