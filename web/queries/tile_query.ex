defmodule Apiv3.TileQuery do
  import Ecto.Query
  alias Apiv3.Tile
  alias Apiv3.TruckQuery

  @preload_fields [:cameras, :batches,
    loading_trucks: TruckQuery.loading_trucks,
    exiting_trucks: TruckQuery.exiting_trucks,
    entering_trucks: TruckQuery.entering_trucks]

  def preload_fields, do: @preload_fields

  @default_scope from t in Tile,
    select: t
  def index(params, %{id: id}) do
    @default_scope
    |> where([t], t.account_id == ^id)
    |> consider_tile_types(params)
    |> preload(^@preload_fields)
  end

  def show(id) do
    from t in Tile,
      where: t.id == ^id,
      select: t,
      preload: ^@preload_fields 
  end

  def consider_tile_types(query, %{"type" => type}) do
    query
    |> where([t], t.tile_type == ^type)
  end
  def consider_tile_types(query, _), do: query
end