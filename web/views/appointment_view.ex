defmodule Apiv3.AppointmentView do
  use Apiv3.Web, :view

  @attributes ~w(permalink appointment_type 
    company_permalink created_at updated_at expected_at
    fulfilled_at cancelled_at exploded_at consumed_at
    coupled_at material_description company notes external_reference)a
  @relationships ~w(batches outgoing_batches dropoffs pickups account)a
  use Apiv3.JsViewConvention
end