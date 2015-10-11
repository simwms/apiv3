defmodule Apiv3.PaymentSubscription do
  use Apiv3.Web, :model

  schema "payment_subscriptions" do
    field :stripe_subscription_id, :string
    field :stripe_token, :string
    field :token_already_consumed, :boolean, default: false
    belongs_to :service_plan, Apiv3.ServicePlan
    belongs_to :account, Apiv3.Account
    has_one :user, through: [:account, :user]
    timestamps
  end

  @required_fields ~w(service_plan_id account_id)
  @optional_fields ~w(stripe_subscription_id stripe_token token_already_consumed)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    params = params |> rename_various_fields
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @name_changes [{"source", "stripe_token"}]
  defp rename_various_fields(params) do
    rename_various_fields(params, @name_changes)
  end

  defp rename_various_fields(params, []), do: params
  defp rename_various_fields(params, [{old_name, new_name}|changes]) do
    case params |> Dict.pop(old_name) do
      {nil, params} -> rename_various_fields(params, changes)
      {value, params} ->
        params
        |> Dict.put(new_name, value)
        |> rename_various_fields(changes)
    end
  end

  
end
