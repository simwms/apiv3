defmodule Apiv3.PictureBuilderTest do
  use Apiv3.ModelCase
  import Apiv3.SeedSupport
  alias Apiv3.Account
  alias Apiv3.Employee
  alias Apiv3.PictureBuilder
  @employee_attr %{
    "full_name" => "Louis CK",
    "email" => "louis@cuck.king",
    "title" => "Cuckold Comedian"
  }

  @picture_attr %{
    "assoc_type" => "employee",
    "location" => "https://s3.amazonaws.com/some-link.jpg"
  }

  test "the changeset should be valid" do
    {account, _} = build_account

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