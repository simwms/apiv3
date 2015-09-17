defmodule Apiv3.Account do
  use Apiv3.Web, :model
  alias Fox.RandomExt
  alias Fox.StringExt
  schema "accounts" do
    field :permalink, :string
    field :service_plan_id, :string
    field :timezone, :string
    field :email, :string
    field :access_key_id, :string
    field :secret_access_key, :string
    field :region, :string
    
    has_many :appointments, Apiv3.Appointment
    has_many :batches, Apiv3.Batch
    has_many :cameras, Apiv3.Camera
    has_many :employees, Apiv3.Employee
    has_many :pictures, Apiv3.Picture
    has_many :tiles, Apiv3.Tile
    has_many :trucks, Apiv3.Truck
    has_many :weightickets, Apiv3.Weighticket
    has_many :appointment_relationships, Apiv3.AppointmentRelationship
    has_many :batch_relationships, Apiv3.BatchRelationship
    timestamps
  end
  
  @required_fields ~w(email service_plan_id timezone)
  @optional_fields ~w(access_key_id secret_access_key region)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  before_insert :punch_permalink
  def punch_permalink(changeset) do
    {x,y,z} = :os.timestamp
    w = RandomExt.uniform(99)
    permalink = "#{z}-#{w}-#{StringExt.random(128)}-#{x}-#{y}"
    changeset |> put_change(:permalink, permalink)
  end
end
