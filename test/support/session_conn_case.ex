defmodule Apiv3.SessionConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Apiv3.ConnCase
      import Apiv3.SeedSupport
      def account_session_conn do
        user = build_user
        {account, _} = build_account(user)
        anon_conn = conn()
        |> put_req_header("accept", "application/json")
        path = anon_conn |> session_path(:create)

        account_conn = anon_conn
        |> post(path, session: %{"email" => user.email, "password" => "password123"})
        |> ensure_recycled
        |> put_req_header("simwms-account-session", account.permalink)

        {account, account_conn}
      end
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Apiv3.Repo, [])
    end

    :ok
  end
end