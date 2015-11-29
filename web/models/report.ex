defmodule Apiv3.Report do
  use Apiv3.Web, :model

  schema "not even a table: report" do
    field :start_at, Timex.Ecto.DateTime
    field :finish_at, Timex.Ecto.DateTime
    belongs_to :account, Apiv3.Account
  end

  @required_atoms ~w(account_id start_at finish_at)a
  @required_fields @required_atoms |> Enum.map(&Atom.to_string/1)
  @optional_fields ~w()
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def createset(%{id: id}, params \\ :empty) do
    params 
    |> Dict.put("account_id", id)
    |> checkset
  end

  def checkset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields, @optional_fields)
  end

  def hashify(changeset) do
    if changeset.valid? do
      report = @required_atoms
      |> Enum.map(fn key -> {key, changeset |> get_field(key)} end)
      |> Enum.into(%{})
      |> generate_encrypted_id
      {:ok, report}
    else
      {:error, changeset}
    end
  end

  def generate_encrypted_id(%{id: x}=h) when is_binary(x) do
    h
  end
  def generate_encrypted_id(hash) do
    id = hash
    |> Poison.encode!
    |> encrypt

    hash |> Dict.put(:id, id)
  end

  def encrypt(string) do
    :sha |> :crypto.hmac(string, master_key) |> Base.encode32
  end

  def master_key do
    Application.get_env(:apiv3, Apiv3.Endpoint)[:simwms_master_key]
  end
end