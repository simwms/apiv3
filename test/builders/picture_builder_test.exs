defmodule Apiv3.PictureBuilderTest do
  use Apiv3.ModelCase
  alias Apiv3.Account
  alias Apiv3.Employee
  alias Apiv3.Picture
  alias Apiv3.PictureBuilder
  @employee_attr %{
    "full_name" => "Louis CK",
    "email" => "louis@cuck.king",
    "title" => "Cuckold Comedian"
  }

  @account_attr %{
    "service_plan_id" => "test",
    "timezone" => "Americas/Los_Angeles",
    "email" => "test@test.test",
    "access_key_id" => "666hailsatan",
    "secret_access_key" => "ikitsu you na planetarium",
    "region" => "Japan"
  }

  @picture_attr %{
    "assoc_type" => "employee",
    "location" => "https://s3.amazonaws.com/some-link.jpg"
  }

  test "the changeset should be valid" do
    account = %Account{}
    |> Account.changeset(@account_attr) 
    |> Repo.insert!

    employee = account
    |> build(:employees)
    |> Employee.changeset(@employee_attr)
    |> Repo.insert!

    changeset = @picture_attr
    |> Dict.put("assoc_id", employee.id)
    |> PictureBuilder.changeset(account)

    assert changeset.valid?
    assert changeset.errors == []

    picture = changeset |> Repo.insert!
    assert picture
    assert picture.id
    assert picture.account_id
    assert picture.assoc_id == employee.id
  end
end