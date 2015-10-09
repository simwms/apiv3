defmodule Apiv3.UserSessionHelper do
  import Plug.Conn
  alias Apiv3.Repo
  alias Apiv3.User
  use Pipe

  @type t :: %__MODULE__{
    logged_in?: boolean,
    user: User | nil,
    errors: [String.t]
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
    conn
    |> get_session(:current_user_id)
    |> find_user_by_id
  end

  def current_user!(conn) do
    user_id = conn |> get_session(:current_user_id)
    Repo.get!(User, user_id)
  end

  def logout!(conn) do
    conn
    |> delete_session(:current_user_id)
  end

  @spec login!(Conn, Map.t) :: {Conn, t}
  def login!(conn, params)do
    result = case find_user(params) do
      {:ok, user} -> authenticate(user, params)
      {:no, message} -> {:no, message}
    end

    case result do
      {:ok, user} -> conn |> success_session(user)
      {:no, message} -> {conn, fail_session(message)}
    end
  end

  def fail_session(message) do
    %__MODULE__{errors: [message]}
  end

  def success_session(conn, user) do
    conn = conn |> put_session(:current_user_id, user.id)
    session = %__MODULE__{logged_in?: true, user: user}
    {conn, session}
  end

  def find_user(%{"email" => email}) when is_binary(email) do
    case User |> Repo.get_by(email: email) do
      nil -> {:no, "no user with that email was found"}
      user -> {:ok, user}
    end
  end

  def find_user(_) do
    {:no, "you need to provide an user login email"}
  end

  def find_user_by_id(nil), do: nil
  def find_user_by_id(id) do
    User |> Repo.get(id)
  end

  def authenticate(nil, _) do
    {:no, "a database bug has occured, please try again in a moment"}
  end

  def authenticate(user, %{"password" => password}) when is_binary(password) do
    case Comeonin.Bcrypt.checkpw(password, user.password_hash) do
      true -> {:ok, user}
      _ -> {:no, "incorrect password"}
    end
  end

end