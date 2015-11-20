defmodule Apiv3.AppointmentRelationshipController do
  use Apiv3.Web, :controller

  alias Apiv3.AppointmentRelationshipQuery, as: Q
  plug :scrub_params, "appointment_relationship" when action in [:create, :update]
  @preload_fields Q.preload_fields

  use Apiv3.AutomagicControllerConvention

  def index(conn, params) do
    account = conn |> current_account
    appointment_relationships = params |> Q.index(account) |> Repo.all
    render(conn, "index.json", appointment_relationships: appointment_relationships)
  end

end
