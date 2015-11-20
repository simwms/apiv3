defmodule Apiv3.Line do
  use Apiv3.Web, :model

  schema "lines" do
    field :points, :string
    field :x, :decimal
    field :y, :decimal
    field :a, :decimal
    field :line_type, :string
    field :line_name, :string

    belongs_to :account, Apiv3.Account
    timestamps 
  end

  @required_fields ~w(line_type x y points)
  @optional_fields ~w(a line_name)

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
