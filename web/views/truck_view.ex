defmodule Apiv3.TruckView do
  use Apiv3.Web, :view
  
  @attributes ~w(arrived_at departed_at docked_at undocked_at created_at updated_at)a
  @relationships ~w(batches account entry_scale exit_scale dock appointment weighticket)a
  use Apiv3.JsViewConvention
end