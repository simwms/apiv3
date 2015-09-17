defmodule Apiv3.AccountBuilderTest do
  use Apiv3.ModelCase
  alias Apiv3.Account
  alias Apiv3.AccountBuilder
  @account_attr %{
    "service_plan_id" => "test",
    "timezone" => "Americas/Los_Angeles",
    "email" => "test@test.test",
    "access_key_id" => "666hailsatan",
    "secret_access_key" => "ikitsu you na planetarium",
    "region" => "Japan"
  }
  test "the changeset should be valid" do
    changeset = Account.changeset(%Account{}, @account_attr)
    assert changeset.valid?
  end

  test "it should properly seed" do
    changeset = Account.changeset(%Account{}, @account_attr)
    {account, [tiles, appointments, batches, employees]} = AccountBuilder.build! changeset
    assert account.id
    assert account.permalink
    assert Enum.count(tiles) == 4
    assert Enum.count(appointments) == 2
    assert Enum.count(batches) == 3
    assert Enum.count(employees) == 1
  end

  test "the seeds should be correct" do
    changeset = Account.changeset(%Account{}, @account_attr)
    {account, [tiles, appointments, batches, [employee]]} = AccountBuilder.build! changeset
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
    assert employee.full_name == "Admin Manager"
  end
end