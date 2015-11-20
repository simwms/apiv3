defmodule Apiv3.Point do
  use Apiv3.Web, :model

  schema "points" do
    field :x, :decimal
    field :y, :decimal
    field :a, :decimal
    field :point_type, :string
    field :point_name, :string

    belongs_to :account, Apiv3.Account
    timestamps 
  end

  @required_fields ~w(point_type x y)
  @optional_fields ~w(a point_name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
