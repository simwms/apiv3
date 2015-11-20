defmodule Apiv3.UserSessionHelperTest do
  use Apiv3.ConnCase
  alias Apiv3.User
  alias Apiv3.UserSessionHelper, as: Session
  import Apiv3.SeedSupport

  @default_opts [
    store: :cookie,
    key: "foobar",
    encryption_salt: "encrypted cookie salt",
    signing_salt: "signing salt"
  ]
  @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))
  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> Plug.Session.call(@signing_opts)
    |> fetch_session

    {:ok, conn: conn, user: build_user}
  end

  test "it should login and remember", %{conn: conn, user: user} do
    params = %{ "email" => user.email, "password" => "password123" }
    {conn, session} = conn |> Session.login!(params)

    assert session.logged_in?
    assert %User{} = session.user
    user = session.user

    date = Timex.Date.now |> Timex.Date.shift(years: 1)
    assert user.remember_token
    assert user.forget_at > date

    conn |> Session.logout!
    user = Repo.get!(User, user.id)

    assert user.forget_at <= Timex.Date.now
  end

  test "it should allow sign-in via header", %{conn: conn, user: user} do
    {:ok, user} = user |> Session.remember_me(nil)

    actual = conn
    |> put_req_header("simwms-user-session", user.remember_token)
    |> Session.current_user

    assert actual.id == user.id
    assert actual.remember_token == user.remember_token
    assert user.remember_token
  end

  test "logging out an user should invalidate the session", %{conn: conn, user: user} do
    {:ok, user} = user |> Session.remember_me(nil)
    user = user |> Session.forget_me

    x = conn
    |> put_req_header("simwms-user-session", user.remember_token)
    |> Session.current_user

    refute x
  end
end