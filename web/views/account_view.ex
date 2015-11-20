defmodule Apiv3.AccountView do
  use Apiv3.Web, :view

  def render("index.json", %{accounts: accounts}) do
    %{accounts: render_many(accounts, "account.json")}
  end

  def render("show.json", %{account: account}) do
    case account.service_plan do
      %Ecto.Association.NotLoaded{} -> 
        %{account: render_one(account, "account.json")}
      nil ->
        %{account: render_one(account, "account.json")}
      service_plan ->
        %{account: render_one(account, "account.json"),
          service_plan: render_one(service_plan, Apiv3.ServicePlanView, "service_plan.json")}
    end
  end

  def render("account.json", %{account: account}) do
    account |> ember_attributes |> reject_blank_keys
  end

  def ember_attributes(account) do
    %{
      id: account.id,
      company_name: account.company_name,
      permalink: account.permalink,
      service_plan_id: just_id(account.service_plan),
      user_id: just_id(account.user),
      timezone: account.timezone,
      email: account.email,
      username: account.user.username,
      access_key_id: account.access_key_id,
      secret_access_key: account.secret_access_key,
      roxie_key: Application.get_env(:apiv3, Apiv3.Endpoint)[:roxie_master_key],
      is_properly_setup: account.payment_subscription.token_already_consumed,
      deleted_at: account.deleted_at,
      inserted_at: account.inserted_at,
      region: account.region
    }
  end
end
