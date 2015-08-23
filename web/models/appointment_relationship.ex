defmodule Apiv3.AppointmentRelationship do
  use Apiv3.Web, :model

  schema "appointment_relationships" do
    field :notes, :string
    belongs_to :dropoff, Apiv3.Appointment, foreign_key: :dropoff_id
    belongs_to :pickup, Apiv3.Appointment, foreign_key: :pickup_id

    belongs_to :account, Apiv3.Account
    timestamps
  end

  @required_fields ~w(dropoff_id pickup_id)
  @optional_fields ~w(notes)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
