defmodule Apiv3.ServicePlan do
  use Apiv3.Web, :model

  schema "service_plans" do
    field :service_plan_id, :string
    field :docks, :integer
    field :employees, :integer
    field :warehouses, :integer
    field :scales, :integer
    field :simwms_name, :string

    belongs_to :account, Apiv3.Account
    timestamps
  end

  @required_fields ~w(service_plan_id)
  @optional_fields ~w(docks employees warehouses scales simwms_name)

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
    service_plan_id = changeset |> get_field(:service_plan_id)
    case changeset |> get_field(:simwms_name) do
      nil -> changeset |> put_change(:simwms_name, service_plan_id)
      _ -> changeset
    end
  end
end
