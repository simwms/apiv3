defmodule Apiv3.AppointmentRelationshipQuery do
  import Ecto.Query
  alias Apiv3.AppointmentRelationship

  @preload_fields [pickup: :dropoffs, dropoff: :pickups]

  def preload_fields, do: @preload_fields
  @default_index_query from a in AppointmentRelationship,
    preload: ^@preload_fields,
    select: a
  def index(%{"dropoff_id" => dropoff_id, "pickup_id" => pickup_id}) do
    @default_index_query
    |> where([a], a.dropoff_id == ^dropoff_id)
    |> where([a], a.pickup_id == ^pickup_id)
  end
  def index(%{"dropoff_id" => id}) do
    @default_index_query
    |> where([a], a.dropoff_id == ^id)
  end
  def index(%{"pickup_id" => id}) do
    @default_index_query
    |> where([a], a.pickup_id == ^id)
  end
  def index(_params) do
    @default_index_query
  end
end