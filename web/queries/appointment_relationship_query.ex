defmodule Apiv3.AppointmentRelationshipQuery do
  import Ecto.Query
  alias Apiv3.AppointmentRelationship

  @preload_fields [pickup: :dropoffs, dropoff: :pickups]

  def preload_fields, do: @preload_fields
  @default_index_query from a in AppointmentRelationship,
    preload: ^@preload_fields,
    select: a

  def index(params, account) do
    query = default_index_query(account)
    ["dropoff_id", "pickup_id"]
    |> Enum.reduce(query, &consider_param(params, &1, &2))
  end

  def consider_param(params, key, query) do
    case params |> Dict.get(key) do
      nil -> query
      id -> query |> where([a], field(a, ^(String.to_existing_atom key)) == ^id)
    end
  end

  def default_index_query(%{id: id}) do
    @default_index_query
    |> where([a], a.account_id == ^id)
  end
end