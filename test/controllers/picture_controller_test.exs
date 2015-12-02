defmodule Apiv3.PictureControllerTest do
  use Apiv3.SessionConnCase
  alias Apiv3.Employee
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  @employee_attr %{
    "full_name" => "Louis CK",
    "email" => "louis@cuck.king",
    "title" => "Cuckold Comedian"
  }

  @picture_attr %{
    "assoc_type" => "employee",
    "location" => "https://s3.amazonaws.com/some-link.jpg"
  }

  test "it should properly create a picture", %{conn: conn, account: account} do
    employee = account
    |> build(:employees)
    |> Employee.changeset(@employee_attr)
    |> Repo.insert!

    path = conn |> picture_path(:create)
    picture_attr = @picture_attr |> Dict.put("assoc_id", employee.id)
    
    response = conn
    |> post(path, picture: picture_attr)
    |> json_response(200)
    picture = response["data"]
    assert picture
    assert picture["id"]
    assert picture["relationships"]["account"]["data"]["id"] == account.id
  end
end