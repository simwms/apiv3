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

  def create(conn, %{"appointment" => appointment_params}) do
    changeset = conn 
    |> current_account
    |> build(:appointments)
    |> Appointment.changeset(appointment_params)

    if changeset.valid? do
      appointment = changeset |> Repo.insert! |> Repo.preload(AppointmentQuery.preload_fields)
      render(conn, "show.json", appointment: appointment)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
