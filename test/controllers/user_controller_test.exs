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
    %{"data" => user} = conn
    |> post(path, %{ "user" => @user_attr})
    |> json_response(201)

    assert %{"id" => _, "type" => "users", "attributes" => attrs} = user
    assert attrs["email"] == @user_attr["email"]
    assert attrs["username"] == @user_attr["username"]
  end
end