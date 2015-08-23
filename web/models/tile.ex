defmodule Apiv3.Tile do
  use Apiv3.Web, :model

  schema "tiles" do
    field :tile_type, :string
    field :tile_name, :string
    field :status, :string
    field :x, :integer
    field :y, :integer
    field :z, :integer
    field :width, :decimal
    field :height, :decimal
    field :deleted_at, Timex.Ecto.DateTime

    has_many :cameras, Apiv3.Camera, foreign_key: :tile_id
    has_many :batches, Apiv3.Batch, foreign_key: :warehouse_id

    has_many :entering_trucks, Apiv3.Truck, foreign_key: :entry_scale_id
    has_many :exiting_trucks, Apiv3.Truck, foreign_key: :exit_scale_id
    has_many :loading_trucks, Apiv3.Truck, foreign_key: :dock_id

    belongs_to :account, Apiv3.Account
    timestamps 
  end

  @required_fields ~w(tile_type x y)
  @optional_fields ~w(deleted_at tile_name status z width height)

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
