defmodule Apiv3.Employee do
  use Apiv3.Web, :model

  schema "employees" do
    field :full_name, :string
    field :title, :string
    field :tile_type, :string
    field :arrived_at, Timex.Ecto.DateTime
    field :left_work_at, Timex.Ecto.DateTime
    field :fired_at, Timex.Ecto.DateTime
    field :phone, :string
    field :email, :string
    field :role, :string, default: "none"
    belongs_to :tile, Apiv3.Tile
    has_many :pictures, {"employee_pictures", Apiv3.Picture}, foreign_key: :assoc_id
    belongs_to :account, Apiv3.Account
    timestamps
  end
  @known_roles ~w(admin_manager admin manager scalemaster dockworker logistics inventory none)
  @required_fields ~w(full_name email role)
  @optional_fields ~w(title tile_type tile_id arrived_at left_work_at phone)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:role, @known_roles)
  end
end
