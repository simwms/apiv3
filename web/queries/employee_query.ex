defmodule Apiv3.EmployeeQuery do
  import Ecto.Query
  alias Apiv3.Employee

  @preload_fields ~w(pictures)a

  def preload_fields, do: @preload_fields

  @default_index_query from e in Employee,
    where: is_nil(e.fired_at),
    order_by: [desc: e.arrived_at]
  def index(_params, %{id: id}) do
    @default_index_query
    |> where([e], e.account_id == ^id)
    |> select([e], e)
    |> preload(^@preload_fields)
  end
end