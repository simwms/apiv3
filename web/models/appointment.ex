defmodule Apiv3.Appointment do
  use Apiv3.Web, :model
  @appointment_types ~w(dropoff pickup both)
  schema "appointments" do
    field :appointment_type, :string
    field :permalink, :string
    field :deleted_at, Timex.Ecto.DateTime
    field :material_description, :string
    field :material_permalink, :string
    field :company, :string
    field :company_permalink, :string
    field :notes, :string
    field :fulfilled_at, Timex.Ecto.DateTime
    field :cancelled_at, Timex.Ecto.DateTime
    field :expected_at, Timex.Ecto.DateTime
    field :exploded_at, Timex.Ecto.DateTime
    field :coupled_at, Timex.Ecto.DateTime
    field :consumed_at, Timex.Ecto.DateTime
    field :external_reference, :string
    has_many :batches, Apiv3.Batch
    has_many :batch_relationships, Apiv3.BatchRelationship, foreign_key: :appointment_id
    has_many :outgoing_batches, through: [:batch_relationships, :batch]
    has_one :weighticket, Apiv3.Weighticket
    has_one :truck, Apiv3.Truck

    has_many :dropoff_relationships, Apiv3.AppointmentRelationship, foreign_key: :pickup_id
    has_many :dropoffs, through: [:dropoff_relationships, :dropoff]

    has_many :pickup_relationships, Apiv3.AppointmentRelationship, foreign_key: :dropoff_id
    has_many :pickups, through: [:pickup_relationships, :pickup]
    belongs_to :account, Apiv3.Account
    timestamps 
  end

  @required_fields ~w(appointment_type
    material_description 
    company 
    expected_at)
  @optional_fields ~w(company_permalink 
    permalink 
    deleted_at
    notes
    material_permalink
    fulfilled_at
    cancelled_at
    exploded_at
    coupled_at
    consumed_at
    external_reference)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:appointment_type, @appointment_types)
  end

  before_insert :create_permalink
  def create_permalink(changeset) do
    changeset
    |> create_company_permalink
    |> create_regular_permalink
  end

  def create_regular_permalink(changeset) do
    company_permalink = Ecto.Changeset.get_field(changeset, :company_permalink)
    type = Ecto.Changeset.get_field(changeset, :appointment_type)
    v = :random.uniform(1000000)
    changeset
    |> Ecto.Changeset.put_change(:permalink, "#{company_permalink}-#{v}-#{type}")
  end

  def create_company_permalink(changeset) do
    company_permalink = changeset |> Ecto.Changeset.get_field(:company) |> Fox.StringExt.to_url
    changeset
    |> Ecto.Changeset.put_change(:company_permalink, company_permalink)
  end
end
