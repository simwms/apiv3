defmodule Apiv3.AccountSessionHelper do
  import Plug.Conn
  alias Apiv3.Repo
  alias Apiv3.Account

  def has_account_session?(conn) do
    case current_account(conn) do
      nil -> {false, nil}
      account -> {true, account}
    end
  end

  def current_account(conn) do
    account_via_session(conn) || account_via_header(conn)
  end

  defp account_via_session(conn) do
    conn
    |> get_session(:current_account)
    |> find_account_by_id
  end

  defp account_via_header(conn) do
    conn
    |> get_req_header("simwms-account-session")
    |> List.first
    |> find_account_by_permalink
  end

  defp find_account_by_id(nil), do: nil
  defp find_account_by_id(id) do
    Repo.get(Account, id)
  end

  defp find_account_by_permalink(nil), do: nil
  defp find_account_by_permalink(permalink) do
    Repo.get_by(Account, permalink: permalink)
  end

  def affirm_account_session!(conn, %{id: id}) when not is_nil id do
    conn
    |> put_session(:current_account, id)
  end
  def affirm_account_session!(conn, _), do: conn
end