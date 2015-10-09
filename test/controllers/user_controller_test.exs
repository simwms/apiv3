defmodule Apiv3.UserControllerTest do
  use Apiv3.ConnCase

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  @user_attr %{
    "email" => Faker.Internet.email,
    "username" => Faker.Name.name,
    "password" => "password123"
  }
  test "create", %{conn: conn} do
    path = conn |> user_path(:create)
    %{"user" => user} = conn
    |> post(path, %{ "user" => @user_attr})
    |> json_response(201)

    assert user["id"]
    assert user["email"] == @user_attr["email"]
    assert user["username"] == @user_attr["username"]
  end
end