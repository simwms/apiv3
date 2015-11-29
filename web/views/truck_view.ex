defmodule Apiv3.TruckView do
  use Apiv3.Web, :view
  
  @attributes ~w(entry_scale_id exit_scale_id dock_id 
    appointment_id weighticket_id arrived_at 
    departed_at docked_at undocked_at created_at updated_at)a
  @relationships ~w(batches account)a
  use Apiv3.JsViewConvention
end