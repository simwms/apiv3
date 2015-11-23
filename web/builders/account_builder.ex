defmodule Apiv3.AccountBuilder do
  use Apiv3.Web, :model
  use Pipe
  alias Apiv3.Account
  alias Apiv3.PaymentSubscription
  alias Apiv3.Repo
  alias Apiv3.ServicePlan
  import Apiv3.EctoUtils

  schema "aggregates: accounts service_plans tiles appointments batches employees" do
    field :region, :string    
    field :timezone, :string
    field :user_id, :integer
    field :service_plan_id, :integer
    
    field :company_name, :string
  end
  @object_fields ~w(service_plan user)
  @required_fields ~w(service_plan_id timezone company_name user_id)
  @optional_fields ~w(region)
  def virtual_changeset(params) do
    params = params |> id_object_cast(@object_fields)
    %__MODULE__{}
    |> cast(params, @required_fields, @optional_fields)
  end

  @account_fields ~w(timezone region company_name)a
  defp account_changeset(changeset) do
    user = changeset |> get_field(:user_id) |> find!(Apiv3.User)
    params = changeset 
    |> fetch_fields(@account_fields)
    |> Dict.put("email", user.email)

    user
    |> build(:accounts)
    |> Account.changeset(params)
  end

  def build!(changeset) do
    account = changeset |> account_changeset |> Repo.insert!
    user = changeset |> get_field(:user_id) |> find!(Apiv3.User)
    plan = changeset |> get_field(:service_plan_id) |> find!(Apiv3.ServicePlan)
    {{a, _, _}, xs} = pipe_with &state/2,
      {{account, user, plan}, []}
      |> seed_tiles
      |> seed_appointments
      |> seed_batches
      |> seed_employees(changeset)
      |> subscribe_to_service_plan(changeset)
      |> seed_lines
    {a, xs}
  end

  def destroy!(account) do
    %{id: id} = ServicePlan.free_trial
    params = %{"token_already_consumed" => false, "service_plan_id" => id}
    account 
    |> assoc(:payment_subscription) 
    |> Repo.one!
    |> PaymentSubscription.changeset(params)
    |> Repo.update!
    |> Apiv3.PaymentSubscriptionController.synchronize_stripe!

    account
    |> Account.changeset(%{"deleted_at" => Timex.Date.local})
    |> Repo.update!
  end

  def state({models, seeds}=acc, f), do: {models, seeds ++ [f.(acc)]}

  @tile_seeds [%{
    "height" => 1, 
    "tile_type" => "dock",
    "width" => 1, 
    "x" => 7, 
    "y" => 2
  },%{
    "height" => 1, 
    "tile_type" => "scale",
    "width" => 1, 
    "x" => 16, 
    "y" => 2
  },%{
    "height" => 1, 
    "tile_type" => "entrance",
    "width" => 1, 
    "x" => 0, 
    "y" => 0
  },%{
    "height" => 1, 
    "tile_type" => "exit",
    "width" => 1, 
    "x" => 19, 
    "y" => 13
  },%{
    "height" => 1, 
    "tile_type" => "cell",
    "width" => 1, 
    "x" => 6, 
    "y" => 6
  },%{
    "height" => 1, 
    "tile_type" => "cell",
    "width" => 1, 
    "x" => 6, 
    "y" => 7
  },%{
    "height" => 1, 
    "tile_type" => "cell",
    "width" => 1, 
    "x" => 7, 
    "y" => 7
  },%{
    "height" => 1, 
    "tile_type" => "cell",
    "width" => 1, 
    "x" => 7, 
    "y" => 6
  },%{
    "height" => 1, 
    "tile_type" => "desk",
    "width" => 1, 
    "x" => 15, 
    "y" => 6
  },%{
    "height" => 1, 
    "tile_type" => "desk",
    "width" => 1, 
    "x" => 15, 
    "y" => 7
  },%{
    "height" => 1, 
    "tile_type" => "desk",
    "width" => 1, 
    "x" => 15, 
    "y" => 8
  }]
  def seed_tiles({{account, _user, _plan}, []}) do
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
  def seed_appointments({{account, _user, _plan}, [_tiles]}) do
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
  def seed_batches({{account, _user, _plan}, [tiles, appointments]}) do
    [dock, _, _, _, warehouse|_] = tiles
    [appointment|_] = appointments
    pipe_with &Enum.map/2,
      @batch_seeds
      |> Dict.put("appointment_id", appointment.id)
      |> Dict.put("dock_id", dock.id)
      |> Dict.put("warehouse_id", warehouse.id)
      |> build_changeset(account, :batches, Apiv3.Batch)
      |> Repo.insert!
  end

  @employee_seed %{ "role" => "admin_manager" }
  def seed_employees({{account, user, _plan}, _}, changeset) do
    %{email: email, username: name} = user
    params = @employee_seed |> Dict.put("full_name", name) |> Dict.put("email", email)
    employee = account 
    |> build(:employees)
    |> Apiv3.Employee.changeset(params)
    |> Repo.insert!
    [employee]
  end

  def subscribe_to_service_plan({{account, _user, plan}, _}, changeset) do
    subscription = plan
    |> build(:payment_subscriptions)
    |> Apiv3.PaymentSubscription.changeset(%{"account_id" => account.id})
    |> Repo.insert!
    [subscription]
  end

  @line_seeds [%{ 
    "line_type" => "road", 
    "points" => "0,0 2,7",
    "x" => 17, 
    "y" => 1
  },%{ 
    "line_type" => "wall", 
    "points" => "0,0 0,-5",
    "x" => 17, 
    "y" => 10
  },%{ 
    "line_type" => "wall", 
    "points" => "0,0 3,0",
    "x" => 14, 
    "y" => 10
  },%{ 
    "line_type" => "wall", 
    "points" => "0,0 3,0",
    "x" => 14, 
    "y" => 5
  },%{ 
    "line_type" => "wall", 
    "points" => "0,0 0,7",
    "x" => 14, 
    "y" => 3
  },%{ 
    "line_type" => "wall", 
    "points" => "0,0 13,0",
    "x" => 1, 
    "y" => 10
  },%{ 
    "line_type" => "wall", 
    "points" => "0,0 0,7",
    "x" => 1, 
    "y" => 3
  },%{ 
    "line_type" => "wall", 
    "points" => "0,0 13,0",
    "x" => 1, 
    "y" => 3
  },%{ 
    "line_type" => "road", 
    "points" => "0,0 0,6",
    "x" => 19, 
    "y" => 8
  },%{ 
    "line_type" => "road", 
    "points" => "0,0 17,0",
    "x" => 0, 
    "y" => 1
  }]
  def seed_lines({{account, _user, _plan}, _}) do
    pipe_with &Enum.map/2,
      @line_seeds 
      |> build_changeset(account, :lines, Apiv3.Line)
      |> Repo.insert!
  end
end