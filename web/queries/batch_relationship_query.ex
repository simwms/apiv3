defmodule Apiv3.BatchRelationshipQuery do
  alias Apiv3.BatchRelationship
  import Ecto.Query

  @preload_fields [batch: :pickup_appointments, appointment: :outgoing_batches]
  @default_index_query from b in BatchRelationship,
    select: b,
    preload: ^@preload_fields
  def index(%{"appointment_id" => aid, "batch_id" => bid}) do
    @default_index_query
    |> where([b], b.appointment_id == ^aid)
    |> where([b], b.batch_id == ^bid)
  end
  def index(%{"appointment_id" => aid}) do
    @default_index_query
    |> where([b], b.appointment_id == ^aid)
  end
  def index(_) do
    @default_index_query
  end

  def preload_fields, do: @preload_fields
end