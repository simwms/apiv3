defmodule Apiv3.BatchRelationshipQuery do
  alias Apiv3.BatchRelationship
  import Ecto.Query

  @preload_fields [batch: :pickup_appointments, appointment: :outgoing_batches]
  @default_index_query from b in BatchRelationship,
    select: b,
    preload: ^@preload_fields
    
  def index(params, account\\nil) do
    query = default_index_query(account)
    ["appointment_id", "batch_id"]
    |> Enum.reduce(query, &consider_where_fields(params, &1, &2))
  end

  def consider_where_fields(params, key, query) do
    case params |> Dict.get(key) do
      nil -> query
      id -> query |> where([b], field(b, ^(String.to_existing_atom key)) == ^id)
    end
  end

  def default_index_query(%{id: id}) do
    @default_index_query
    |> where([b], b.account_id == ^id)
  end
  def default_index_query(_), do: @default_index_query

  def preload_fields, do: @preload_fields
end