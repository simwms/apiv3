defmodule Apiv3.User do
  use Apiv3.Web, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
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

  @creation_fields ~w(email username password)
  @updative_fields ~w(username)
  @optional_fields ~w(recovery_hash remember_token forget_at stripe_customer_id)
  @password_hash_opts [min_length: 1, extra_chars: false, common: false]
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model 
    |> cast(params, @updative_fields, @optional_fields)
    |> unique_constraint(:username)
  end

  def password_reset(model, password) when is_binary(password) do
    model
    |> cast(%{"password" => password}, ["password"])
    |> encrypt_password
  end

  def createset(params\\:empty) do
    %__MODULE__{}
    |> cast(params, @creation_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: @password_hash_opts[:min_length])
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def remember_me_changeset(user) do
    %{email: email, password_hash: pw} = user
    user |> remember_me_core(email, pw)    
  end

  def forget_me_changeset(user) do
    user |> changeset(%{"forget_at" => Timex.Date.now})
  end

  before_insert :encrypt_password
  def encrypt_password(changeset) do
    {:ok, password_hash} = changeset
    |> get_field(:password)
    |> Comeonin.create_hash(@password_hash_opts)

    changeset
    |> put_change(:password_hash, password_hash)
  end

  before_insert :setup_remember_token
  def setup_remember_token(changeset) do
    {:changes, email} = changeset |> fetch_field(:email)
    {:changes, hash} = changeset |> fetch_field(:password_hash)

    changeset |> remember_me_core(email, hash)
  end

  def remember_me_core(user, email, pw) do
    key = "#{email}-#{pw}"
    {x,y,z} = :os.timestamp
    salt = "#{x}-#{y}-#{z}"
    token = :sha256 |> :crypto.hmac(key, salt) |> Base.encode32
    date = Timex.Date.now |> Timex.Date.shift(years: 5)

    user
    |> changeset(%{"remember_token" => token, "forget_at" => date})
  end
end
