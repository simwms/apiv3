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
    assert session["remember_token"]
    assert current_user_id == user.id
  end

  @bad_attr %{
    "email" => "not-a-good-email@wrong.co",
    "password" => "hacker21"
  }
  test "wrong email", %{conn: conn, user: user} do
    path = conn |> session_path(:create)
    conn = conn |> post(path, %{ "session" => @bad_attr})
    %{"errors" => errors} = conn |> json_response(422)

    refute conn |> get_session(:current_user_id)
    assert errors == %{"email" => "no such user"}
  end

  test "wrong password", %{conn: conn, user: user} do
    attr = @user_attr |> Dict.put("password", "wrong-pass")
    path = conn |> session_path(:create)
    conn = conn |> post(path, %{ "session" => attr})
    %{"errors" => errors} = conn |> json_response(422)

    refute conn |> get_session(:current_user_id)
    assert errors == %{"password" => "wrong password"}
  end

  test "delete", %{conn: conn, user: user} do
    create_path = conn |> session_path(:create)
    path = conn |> session_path(:delete)
    conn = conn
    |> post(create_path, %{"session" => @user_attr})
    |> delete(path, %{})

    refute conn |> get_session(:current_user_id)
  end

  test "show", %{conn: conn, user: user} do
    create_path = conn |> session_path(:create)
    path = conn |> session_path(:show)
    %{"session" => session} = conn
    |> post(create_path, %{"session" => @user_attr})
    |> get(path, %{})
    |> json_response(200)

    assert session["id"] == user.id
  end

end