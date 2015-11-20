defmodule Apiv3.ServicePlan do
  use Apiv3.Web, :model
  alias Apiv3.ServicePlanHarmonizer, as: Harmonizer
  alias Apiv3.Stargate

  schema "service_plans" do
    field :stripe_plan_id, :string
    field :docks, :integer
    field :employees, :integer
    field :warehouses, :integer
    field :scales, :integer
    field :simwms_name, :string
    field :monthly_price, :integer, default: 0
    field :description, :string
    field :presentation, :string
    field :synced_with_stripe, :boolean, default: false
    field :deprecated_at, Timex.Ecto.DateTime
    has_many :payment_subscriptions, Apiv3.PaymentSubscription
    has_many :accounts, through: [:payment_subscriptions, :account]
    timestamps
  end

  @required_fields ~w(stripe_plan_id monthly_price)
  @optional_fields ~w(docks employees warehouses scales simwms_name description presentation synced_with_stripe deprecated_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> infer_simwms_name
  end

  def infer_simwms_name(changeset) do
    stripe_plan_id = changeset |> get_field(:stripe_plan_id)
    case changeset |> get_field(:simwms_name) do
      nil -> changeset |> put_change(:simwms_name, stripe_plan_id)
      _ -> changeset
    end
  end

  @free_trial_plan %{
    "stripe_plan_id" => "free-trial-seed",
    "presentation" => "Free Trial",
    "version" => "seed",
    "description" => "Trial plan lets you try out the software on a small pretend warehouse.",
    "monthly_price" => 0,
    "docks" => 1,
    "scales" => 1,
    "warehouses" => 4,
    "employees" => 5
  }
  def free_trial do
    find_free_trial() || make_free_trial()
  end

  defp find_free_trial do
    __MODULE__ |> Repo.get_by(stripe_plan_id: "free-trial-seed") 
  end

  defp make_free_trial do
    plan = %__MODULE__{}
    |> changeset(@free_trial_plan)
    |> Repo.insert!

    plan
    |> Harmonizer.harmonize
    |> Stargate.warp_sync

    plan
  end

end
