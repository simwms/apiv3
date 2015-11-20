defmodule Apiv3.Account do
  use Apiv3.Web, :model
  alias Fox.RandomExt
  alias Fox.StringExt
  schema "accounts" do
    field :permalink, :string
    field :timezone, :string
    field :email, :string
    field :access_key_id, :string
    field :secret_access_key, :string
    field :region, :string
    field :deleted_at, Timex.Ecto.DateTime
    field :company_name, :string
    field :is_properly_setup, :boolean, default: false
    belongs_to :user, Apiv3.User

    has_one :payment_subscription, Apiv3.PaymentSubscription
    has_one :service_plan, through: [:payment_subscription, :service_plan]
    has_one :stripe_plan_id, through: [:service_plan, :stripe_plan_id]

    has_many :appointments, Apiv3.Appointment
    has_many :batches, Apiv3.Batch
    has_many :cameras, Apiv3.Camera
    has_many :employees, Apiv3.Employee
    has_many :pictures, Apiv3.Picture
    has_many :tiles, Apiv3.Tile
    has_many :trucks, Apiv3.Truck
    has_many :weightickets, Apiv3.Weighticket
    has_many :appointment_relationships, Apiv3.AppointmentRelationship
    has_many :batch_relationships, Apiv3.BatchRelationship
    has_many :points, Apiv3.Point
    has_many :lines, Apiv3.Line
    timestamps
  end
  
  @required_fields ~w(email timezone company_name)
  @optional_fields ~w(access_key_id secret_access_key region is_properly_setup deleted_at)

  def createset(model, params\\:empty) do
    model |> cast(params, @required_fields)
  end
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  before_insert :punch_permalink
  def punch_permalink(changeset) do
    email = changeset |> get_field(:email)
    service_plan_id = changeset |> get_field(:service_plan_id)
    timezone = changeset |> get_field(:timezone)
    key = "#{email}-#{service_plan_id}-#{timezone}"
    {x,y,z} = :os.timestamp
    salt = "#{x}-#{y}-#{z}"
    
    permalink = :sha256 |> :crypto.hmac(key, salt) |> Base.encode32
    changeset |> put_change(:permalink, permalink)
  end

  def get_service_plan(%{service_plan: %Apiv3.ServicePlan{}=plan}), do: plan
  def get_service_plan(account) do
    account |> assoc(:service_plan) |> Repo.one
  end

  def get_user(%{user: %Apiv3.User{}=user}), do: user
  def get_user(account) do
    account |> assoc(:user) |> Repo.one
  end 

  def increment_attempt!(%{setup_attempts: n}=account) do
    account
    |> change(setup_attempts: n + 1)
    |> Repo.update!
  end

  def ensure_payment_subscription(account) do
    case account.payment_subscription do
      nil -> account |> Apiv3.PaymentSubscription.free_trial
      payment_subscription when not is_nil(payment_subscription) -> payment_subscription
    end
  end

  def synchronize_stripe(account) do
    account = account |> Repo.preload(:user)
    account.user |> Apiv3.User.synchronize_stripe
    account
  end

  before_update :check_proper_setup
  @doc """
  If all the optional fields have values, then the account is properly setup
  """
  def check_proper_setup(changeset) do
    x = changeset |> all_fields_present?
    changeset |> put_change(:is_properly_setup, x)
  end

  defp all_fields_present?(changeset) do
    @optional_fields
    |> Enum.map(&String.to_existing_atom/1)
    |> Enum.all?(&has_value?(changeset, &1))
  end

  defp has_value?(changeset, key) do
    case changeset |> fetch_field(key) do
      {_, x} when not is_nil x -> true
      _ -> false
    end
  end
end
