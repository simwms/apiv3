defmodule Apiv3.SeedSupport do
  alias Apiv3.User
  alias Apiv3.ServicePlan
  alias Apiv3.Repo
  alias Apiv3.AccountBuilder

  def account_attr do
   %{
      "company_name" => Faker.Company.name,
      "timezone" => "Americas/Los_Angeles"
    }
  end
  def user_attr do
   %{
      "email" => Faker.Internet.email,
      "username" => Faker.Name.name,
      "password" => "password123"
    }
  end
  def plan_attr(stripe_plan_id\\"free-trial-seed") do
   %{
      "stripe_plan_id" => stripe_plan_id,
      "presentation" => "Test",
      "version" => "seed",
      "description" => "Test plan, should not be visible for selection",
      "monthly_price" => 0
    }
  end
  def build_account(user\\build_user, plan\\build_service_plan) do
    account_attr
    |> Dict.put("user", user) 
    |> Dict.put("service_plan", plan)
    |> AccountBuilder.virtual_changeset
    |> AccountBuilder.build!
  end
  def build_user do
    user_attr |> User.createset |> Repo.insert!
  end
  def build_service_plan(stripe_plan_id\\"free-trial-seed") do
    %ServicePlan{} |> ServicePlan.changeset(plan_attr(stripe_plan_id)) |> Repo.insert!
  end
end