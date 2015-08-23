defmodule Apiv3.Batch do
  use Apiv3.Web, :model
  @batch_types ~w(incoming outgoing split)

  schema "batches" do
    field :outgoing_count, :integer, default: 0
    field :permalink, :string
    field :description, :string
    field :quantity, :string
    field :deleted_at, Timex.Ecto.DateTime
    belongs_to :dock, Apiv3.Tile, foreign_key: :dock_id
    belongs_to :warehouse, Apiv3.Tile, foreign_key: :warehouse_id
    belongs_to :appointment, Apiv3.Appointment, foreign_key: :appointment_id
    belongs_to :truck, Apiv3.Truck, foreign_key: :truck_id
    has_many :relationships, Apiv3.BatchRelationship, foreign_key: :batch_id
    has_many :pickup_appointments, through: [:relationships, :appointment]
    has_many :pictures, {"batch_pictures", Apiv3.Picture}, foreign_key: :assoc_id
    belongs_to :account, Apiv3.Account
    timestamps 
  end

  @required_fields ~w(warehouse_id outgoing_count)
  @optional_fields ~w(dock_id appointment_id description permalink quantity truck_id deleted_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:batch_type, @batch_types)
  end

  before_insert :create_permalink
  def create_permalink(changeset) do
    permalink = changeset |> Ecto.Changeset.get_field(:permalink)
    appointment_id = changeset |> Ecto.Changeset.get_field(:appointment_id)
    v = :random.uniform(1000000)
    changeset
    |> Ecto.Changeset.put_change(:permalink, "#{v}-#{permalink || appointment_id}")
  end
end
