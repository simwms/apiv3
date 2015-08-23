defmodule Apiv3.BatchRelationship do
  use Apiv3.Web, :model

  schema "batch_relationships" do
    belongs_to :batch, Apiv3.Batch
    belongs_to :appointment, Apiv3.Appointment
    field :notes, :string
    belongs_to :account, Apiv3.Account
    timestamps
  end

  @required_fields ~w(batch_id appointment_id)
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
