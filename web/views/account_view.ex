defmodule Apiv3.AccountView do
  use Apiv3.Web, :view

  def render("index.json", %{accounts: accounts}) do
    %{accounts: render_many(accounts, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{account: render_one(account, "account.json")}
  end

  def render("account.json", %{account: account}) do
    account |> ember_attributes |> reject_blank_keys
  end

  def ember_attributes(account) do
    %{
      id: account.id,
      permalink: account.permalink,
      service_plan_id: account.service_plan_id,
      timezone: account.timezone,
      email: account.email,
      access_key_id: account.access_key_id,
      secret_access_key: account.secret_access_key,
      region: account.region
    }
  end
end
