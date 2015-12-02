defmodule Apiv3.AppointmentRelationshipView do
  use Apiv3.Web, :view

  @attributes ~w(notes created_at updated_at)a
  @relationships ~w(pickup dropoff account)a
  use Apiv3.JsViewConvention
end
