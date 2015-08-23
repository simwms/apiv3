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
    {account, [tiles, appointments, batches]} = AccountBuilder.build! changeset
    assert account.id
    assert account.permalink
    assert Enum.count(tiles) == 4
    assert Enum.count(appointments) == 2
    assert Enum.count(batches) == 3
  end
end