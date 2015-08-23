defmodule Apiv3.AppointmentController do
  use Apiv3.Web, :controller

  alias Apiv3.Appointment
  alias Apiv3.AppointmentMeta
  alias Apiv3.AppointmentQuery
  plug :scrub_params, "appointment" when action in [:create, :update]
  @preload_fields AppointmentQuery.preload_fields
  use Apiv3.AutomagicControllerConvention
  
  def index(conn, params) do
    account = conn |> current_account

    appointments = params
    |> Apiv3.AppointmentQuery.index(account)
    |> Repo.all
    |> Repo.preload(AppointmentQuery.preload_fields)
    meta = params |> AppointmentMeta.generate(account)
    render(conn, "index.json", appointments: appointments, meta: meta)
  end

end
