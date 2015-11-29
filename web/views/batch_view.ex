defmodule Apiv3.BatchView do
  use Apiv3.Web, :view

  @attributes ~w(permalink description quantity deleted_at
    outgoing_count created_at updated_at)a
  @relationships ~w(pickup_appointments pictures account appointment warehouse dock truck)a
  use Apiv3.JsViewConvention
end
