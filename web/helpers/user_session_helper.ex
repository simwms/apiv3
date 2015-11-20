defmodule Apiv3.UserSessionHelper do
  import Plug.Conn
  alias Apiv3.Repo
  alias Apiv3.User
  use Pipe
  use Timex
  import Ecto.Query, only: [from: 2]

  @type t :: %__MODULE__{
    logged_in?: boolean,
    user: User | nil,
    errors: [%{atom => String.t}]
  }
  defstruct logged_in?: false,
    user: nil,
    errors: []

  def has_user_session?(conn) do
    case conn |> current_user do
      nil -> {false, nil}
      user -> {true, user}
    end
  end

  def current_user(conn) do
    (conn |> user_from_session) || (conn |> user_from_header)
  end

  def user_from_header(conn) do
    conn
    |> get_req_header("simwms-user-session")
    |> List.first
    |> find_user_by_remember_token
  end

  def user_from_session(conn) do
    conn
    |> get_session(:current_user_id)
    |> find_user_by_id
  end

  def current_user!(conn) do
    case conn |> current_user do
      nil -> raise("Expected user to be logged in, but wasn't")
      user -> user
    end
  end

  def logout!(conn) do
    # conn |> current_user |> forget_me
    conn |> delete_session(:current_user_id)
  end

  @spec login!(Conn, Map.t) :: {Conn, t}
  def login!(conn, params)do
    result = case find_user(params) do
      {:ok, user} -> authenticate(user, params)
      {:no, messages} -> {:no, messages}
    end

    result = case result do
      {:ok, user} -> remember_me(user, params)
      {:no, messages} -> {:no, messages}
    end

    case result do
      {:ok, user} -> conn |> success_session(user)
      {:no, messages} -> {conn, fail_session(messages)}
    end
  end

  def fail_session(messages) do
    %__MODULE__{errors: messages}
  end

  def success_session(conn, user) do
    conn = conn |> put_session(:current_user_id, user.id)
    session = %__MODULE__{logged_in?: true, user: user}
    {conn, session}
  end

  def find_user(%{"email" => email}) when is_binary(email) do
    case User |> Repo.get_by(email: email) do
      nil -> {:no, %{email: "no such user"}}
      user -> {:ok, user}
    end
  end
  def find_user(_) do
    {:no, %{email: "you need to provide an user login email"}}
  end

  def forget_me(nil), do: nil
  def forget_me(user) do
    user |> User.forget_me_changeset |> Repo.update!
  end

  def remember_me(user, %{"dont_remember_me" => true}) do
    {:ok, user}
  end

  def remember_me(user, _) do
    {:ok, user |> User.remember_me_changeset |> Repo.update! }
  end

  def find_user_by_remember_token(nil), do: nil
  def find_user_by_remember_token(token) do
    date = Date.now |> DateFormat.format!("{ISO}")
    query = from u in User,
      where: u.remember_token == ^token,
      where: is_nil(u.forget_at) or u.forget_at > ^date,
      select: u
    Repo.one query
  end

  def find_user_by_id(nil), do: nil
  def find_user_by_id(id) do
    User |> Repo.get(id)
  end

  def authenticate(nil, _) do
    {:no, %{system: "a database bug has occured, please try again in a moment"}}
  end

  def authenticate(user, %{"password" => password}) when is_binary(password) do
    case Comeonin.Bcrypt.checkpw(password, user.password_hash) do
      true -> {:ok, user}
      _ -> {:no, %{password: "wrong password"}}
    end
  end

end