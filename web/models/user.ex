defmodule Apiv3.User do
  use Apiv3.Web, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_hash, :string
    field :recovery_hash, :string
    field :remember_token, :string
    field :forget_at, Timex.Ecto.DateTime
    field :remembered_at, Timex.Ecto.DateTime
    field :stripe_customer_id, :string
    
    has_many :employees, Apiv3.Employee, foreign_key: :email, references: :email
    has_many :accounts, Apiv3.Account
    timestamps
  end

  @required_fields ~w(email username password_hash)
  @optional_fields ~w(recovery_hash remember_token forget_at stripe_customer_id)
  @password_hash_opts [min_length: 1, extra_chars: false]
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    params = params |> process_params
    model 
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def remember_me_changeset(user) do
    %{email: email, password_hash: pw} = user
    key = "#{email}-#{pw}"
    {x,y,z} = :os.timestamp
    salt = "#{x}-#{y}-#{z}"
    token = :sha256 |> :crypto.hmac(key, salt) |> Base.encode64
    date = Timex.Date.now |> Timex.Date.shift(years: 5)

    user
    |> changeset(%{"remember_token" => token, "forget_at" => date})
  end

  def forget_me_changeset(user) do
    user |> changeset(%{"forget_at" => Timex.Date.now})
  end

  def process_params(%{"password" => _}=params) do
    case params |> Comeonin.create_user(@password_hash_opts) do
      {:ok, p} -> p 
      {:error, _} -> params
    end
  end
  def process_params(%{password: _}=params) do
    case params |> Comeonin.create_user(@password_hash_opts) do
      {:ok, p} -> p 
      {:error, _} -> params
    end
  end
  def process_params(p), do: p
end
