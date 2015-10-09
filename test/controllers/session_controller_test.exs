defmodule Apiv3.SessionControllerTest do
  use Apiv3.ConnCase
  alias Apiv3.User
  @user_attr %{
    "email" => Faker.Internet.email,
    "username" => Faker.Name.name,
    "password" => "password123"
  }
  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    user = %User{} |> User.changeset(@user_attr) |> Repo.insert!
    {:ok, conn: conn, user: user}
  end

  test "create", %{conn: conn, user: user} do
    path = conn |> session_path(:create)
    conn = conn |> post(path, %{ "session" => @user_attr})
    %{"session" => session} = conn |> json_response(201)

    current_user_id = conn |> get_session(:current_user_id)
    assert session["id"] == user.id
    assert current_user_id == user.id
  end

  test "delete", %{conn: conn, user: user} do
    create_path = conn |> session_path(:create)
    path = conn |> session_path(:delete)
    conn = conn
    |> post(create_path, %{"session" => @user_attr})
    |> delete(path, %{})

    refute conn |> get_session(:current_user_id)
  end
end