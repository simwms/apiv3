defmodule Apiv3.SessionConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Apiv3.ConnCase
      alias Apiv3.Account
      @account_attr %{
        "service_plan_id" => "test",
        "timezone" => "Americas/Los_Angeles",
        "email" => "test@test.test",
        "access_key_id" => "666hailsatan",
        "secret_access_key" => "ikitsu you na planetarium",
        "region" => "Japan"
      }
      def account_session_conn do
        {account, _} = build_account

        conn = conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("simwms-account-session", account.permalink)
        {account, conn}
      end
      
      def build_account do
        %Account{}
        |> Account.changeset(@account_attr) 
        |> Apiv3.AccountBuilder.build!
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