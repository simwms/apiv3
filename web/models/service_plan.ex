defmodule Apiv3.ServicePlan do
  use Apiv3.Web, :model

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

    has_many :payment_subscriptions, Apiv3.PaymentSubscription
    has_many :accounts, through: [:payment_subscriptions, :account]
    timestamps
  end

  @required_fields ~w(stripe_plan_id monthly_price)
  @optional_fields ~w(docks employees warehouses scales simwms_name description presentation synced_with_stripe)

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

  def free_trial do 
    __MODULE__ |> Repo.get_by!(stripe_plan_id: "free-trial-seed")
  end

end
