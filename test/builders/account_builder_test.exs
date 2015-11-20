defmodule Apiv3.AccountBuilderTest do
  use Apiv3.ModelCase
  alias Apiv3.AccountBuilder
  alias Apiv3.User
  alias Apiv3.ServicePlan
  @account_attr %{
    "company_name" => "Some Test Co",
    "timezone" => "Americas/Los_Angeles"
  }
  @user_attr %{
    "email" => Faker.Internet.email,
    "username" => Faker.Name.name,
    "password" => "password123"
  }
  @plan_attr %{
    "stripe_plan_id" => "seed-test",
    "presentation" => "Test",
    "version" => "seed",
    "description" => "Test plan, should not be visible for selection",
    "monthly_price" => 0
  }
  setup do
    user = User.createset(@user_attr) |> Repo.insert!
    plan = %ServicePlan{} |> ServicePlan.changeset(@plan_attr) |> Repo.insert!
    account_attr = @account_attr |> Dict.put("user", user) |> Dict.put("service_plan", plan)
    {:ok, user: user, plan: plan, account_attr: account_attr}
  end

  test "the changeset should be valid", %{account_attr: account_attr} do
    changeset = AccountBuilder.virtual_changeset(account_attr)
    assert changeset.valid?
  end

  test "it should properly seed", %{account_attr: account_attr} do
    changeset = AccountBuilder.virtual_changeset(account_attr)
    {account, [tiles, appointments, batches, employees, subscriptions]} = AccountBuilder.build! changeset
    assert account.id
    assert account.permalink
    assert Enum.count(tiles) == 4
    assert Enum.count(appointments) == 2
    assert Enum.count(batches) == 3
    assert Enum.count(employees) == 1
    assert Enum.count(subscriptions) == 1
  end

  test "the seeds should be correct",  %{account_attr: account_attr, plan: plan} do
    changeset = AccountBuilder.virtual_changeset(account_attr)
    {account, [tiles, appointments, batches, [employee], [subscription]]} = AccountBuilder.build! changeset
    [appointment|_] = appointments
    [dock, warehouse, scale, road] = tiles
    
    assert dock.tile_type == "barn"
    assert warehouse.tile_type == "warehouse"
    assert scale.tile_type == "scale"
    assert road.tile_type == "road"

    Enum.map batches, fn batch ->
      assert batch.account_id == account.id
      assert batch.appointment_id == appointment.id
      assert batch.dock_id == dock.id
      assert batch.warehouse_id == warehouse.id
    end

    assert employee.email == account.email
    assert employee.full_name == @user_attr["username"]

    assert subscription.service_plan_id == plan.id
    assert subscription.account_id == account.id
  end
end