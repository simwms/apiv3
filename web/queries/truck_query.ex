defmodule Apiv3.TruckQuery do
  import Ecto.Query
  alias Apiv3.Truck

  @default_scope from t in Truck,
    where: is_nil(t.departed_at)
  def index(_params, %{id: id}) do
    @default_scope
    |> where([t], t.account_id == ^id)
    |> select([t], t)
  end

  def loading_trucks do
    @default_scope
    |> where([t], is_nil(t.undocked_at))
  end

  def exiting_trucks do
    @default_scope
    |> where([t], not is_nil(t.undocked_at))
  end

  def entering_trucks do
    @default_scope
    |> where([t], is_nil(t.docked_at))
  end

end