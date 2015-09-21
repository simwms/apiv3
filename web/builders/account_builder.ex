defmodule Apiv3.AccountBuilder do
  use Apiv3.Web, :model
  use Pipe
  alias Apiv3.Account
  alias Apiv3.Repo

  schema "aggregates: accounts service_plans tiles appointments batches employees" do
    field :region, :string
    field :access_key_id, :string
    field :secret_access_key, :string
    field :email, :string
    field :service_plan_id, :string
    field :timezone, :string
    field :docks, :integer
    field :warehouses, :integer
    field :scales, :integer
    field :employees, :integer
    field :simwms_name, :string
    field :owner_name, :string
  end
  @required_fields ~w(email service_plan_id timezone)
  @optional_fields ~w(docks warehouses scales employees simwms_name owner_name region access_key_id secret_access_key)
  def virtual_changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
  end
  
  @account_fields ~w(email service_plan_id timezone region access_key_id secret_access_key)a
  defp account_changeset(changeset) do
    params = changeset |> fetch_fields(@account_fields)
    %Account{} |> Account.changeset(params)
  end

  defp fetch_fields(changeset, fields), do: changeset |> fetch_fields(fields, %{})
  defp fetch_fields(_, [], p), do: p
  defp fetch_fields(changeset, [field|fields], params) do
    value = changeset |> get_field(field)
    field = field |> Atom.to_string
    params = params |> Dict.put(field, value)
    fetch_fields(changeset, fields, params)
  end

  def build!(changeset) do
    account = changeset |> account_changeset |> Repo.insert!
    pipe_with &state/2,
      {account, []}
      |> seed_tiles
      |> seed_appointments
      |> seed_batches
      |> seed_employees(changeset)
      |> seed_service_plan(changeset)
  end

  def state({account, seeds}=acc, f), do: {account, seeds ++ [f.(acc)]}

  @tile_seeds [
    %{
      "tile_type" => "barn",
      "x" => 2,
      "y" => 2,
      "width" => 1.0,
      "height" => 1.0
    },
    %{
      "tile_type" => "warehouse",
      "x" => 2,
      "y" => 3,
      "width" => 1.0,
      "height" => 1.0
    },
    %{
      "tile_type" => "scale",
      "tile_name" => "entrance scale",
      "x" => 1,
      "y" => 1,
      "width" => 1.0,
      "height" => 1.0
    },
    %{
      "tile_type" => "road",
      "x" => 1,
      "y" => 2,
      "width" => 1.0,
      "height" => 1.0
    }
  ]
  def seed_tiles({account, []}) do
    pipe_with &Enum.map/2,
      @tile_seeds 
      |> build_changeset(account, :tiles, Apiv3.Tile)
      |> Repo.insert!
  end

  @appointment_seeds [%{
    "appointment_type" => "dropoff",
    "material_description" => "test appointment material",
    "company" => "seed test company",
    "expected_at" => Ecto.DateTime.local,
    "fulfilled_at" => Ecto.DateTime.local
  }, %{
    "appointment_type" => "dropoff",
    "material_description" => "not a real material",
    "company" => "base test inc",
    "expected_at" => Ecto.DateTime.local,
    "fulfilled_at" => Ecto.DateTime.local
  }]
  def seed_appointments({account, [_tiles]}) do
    pipe_with &Enum.map/2,
      @appointment_seeds
      |> Dict.put("expected_at", Timex.Date.local)
      |> Dict.put("fulfilled_at", Timex.Date.local)
      |> build_changeset(account, :appointments, Apiv3.Appointment)
      |> Repo.insert!
  end

  @batch_seeds [%{
    "permalink" => "basic-seed-001",
    "description" => "test batch",
    "quantity" => "some amount"
  }, %{
    "permalink" => "basic-seed-002",
    "description" => "test batch",
    "quantity" => "some amount"
  }, %{
    "permalink" => "basic-seed-003",
    "description" => "test batch",
    "quantity" => "some amount"
  }]
  def seed_batches({account, [tiles, appointments]}) do
    [dock, warehouse|_] = tiles
    [appointment|_] = appointments
    pipe_with &Enum.map/2,
      @batch_seeds
      |> Dict.put("appointment_id", appointment.id)
      |> Dict.put("dock_id", dock.id)
      |> Dict.put("warehouse_id", warehouse.id)
      |> build_changeset(account, :batches, Apiv3.Batch)
      |> Repo.insert!
  end

  def build_changeset(params, account, relationship_key, model_class) do
    Ecto.Model.build(account, relationship_key)
    |> model_class.changeset(params)
  end

  @employee_seed %{ "role" => "admin_manager" }
  def seed_employees({account, _}, changeset) do
    %{email: email} = account
    full_name = (changeset |> get_field(:owner_name)) || "Admin Manager"
    params = @employee_seed |> Dict.put("full_name", full_name) |> Dict.put("email", email)
    employee = account 
    |> build(:employees)
    |> Apiv3.Employee.changeset(params)
    |> Repo.insert!
    [employee]
  end

  @service_plan_fields ~w(docks warehouses scales employees simwms_name service_plan_id)a
  def seed_service_plan({account, _}, changeset) do
    params = changeset |> fetch_fields(@service_plan_fields)
    plan = account
    |> build(:service_plan)
    |> Apiv3.ServicePlan.changeset(params)
    |> Repo.insert!
    [plan]
  end
end