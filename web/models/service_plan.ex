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

    has_many :payment_subscriptions, Apiv3.PaymentSubscription
    has_many :accounts, through: [:payment_subscriptions, :account]
    timestamps
  end

  @required_fields ~w(stripe_plan_id monthly_price)
  @optional_fields ~w(docks employees warehouses scales simwms_name description presentation)

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
    __MODULE__ |> Repo.get_by!(stripe_plan_id: "free-trial-seed") |> synchronize_stripe
  end

  def synchronize_stripe(service_plan) do
    case service_plan.stripe_plan_id do
      nil -> initialize_stripe(service_plan)
      _ -> service_plan
    end
  end

  defp initialize_stripe(service_plan) do
    {:ok, stripe_plan} = find_or_create_stripe_plan service_plan

    service_plan
    |> changeset(%{"stripe_plan_id" => stripe_plan.id})
    |> Repo.update!
  end

  defp find_or_create_stripe_plan(service_plan) do
    case service_plan.permalink |> Stripex.Plans.retrieve do
      {:error, %{status_code: 404}} -> 
        Stripex.Plans.create id: service_plan.permalink,
          amount: service_plan.monthly_price,
          currency: "usd",
          name: service_plan.presentation,
          interval: "month",
          statement_descriptor: "simwms cloud service"
      {:ok, plan} -> {:ok, plan}
    end
  end
end
