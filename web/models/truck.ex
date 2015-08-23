defmodule Apiv3.Truck do
  use Apiv3.Web, :model

  schema "trucks" do
    field :arrived_at, Timex.Ecto.DateTime
    field :departed_at, Timex.Ecto.DateTime
    field :docked_at, Timex.Ecto.DateTime
    field :undocked_at, Timex.Ecto.DateTime

    belongs_to :entry_scale, Apiv3.Tile, foreign_key: :entry_scale_id
    belongs_to :exit_scale, Apiv3.Tile, foreign_key: :exit_scale_id
    belongs_to :dock, Apiv3.Tile, foreign_key: :dock_id
    belongs_to :appointment, Apiv3.Appointment, foreign_key: :appointment_id
    belongs_to :weighticket, Apiv3.Weighticket, foreign_key: :weighticket_id

    has_many :batches, Apiv3.Batch, foreign_key: :truck_id
    
    belongs_to :account, Apiv3.Account
    timestamps 
  end

  @required_fields ~w()
  @optional_fields ~w(entry_scale_id 
    exit_scale_id 
    dock_id 
    appointment_id 
    weighticket_id 
    arrived_at 
    departed_at
    docked_at
    undocked_at)

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
