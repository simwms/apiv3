defmodule Apiv3.AppointmentRelationshipController do
  use Apiv3.Web, :controller

  alias Apiv3.AppointmentRelationship
  alias Apiv3.AppointmentRelationshipQuery, as: Q
  plug :scrub_params, "appointment_relationship" when action in [:create, :update]

  def index(conn, params) do
    appointment_relationships = params |> Q.index |> Repo.all
    render(conn, "index.json", appointment_relationships: appointment_relationships)
  end

  def show(conn, %{"id" => id}) do
    appointment_relationship = Repo.get!(AppointmentRelationship, id)
    |> Repo.preload(Q.preload_fields)
    render conn, "show.json", appointment_relationship: appointment_relationship
  end

  def create(conn, %{"appointment_relationship" => appointment_relationship_params}) do
    changeset = AppointmentRelationship.changeset(%AppointmentRelationship{}, appointment_relationship_params)

    if changeset.valid? do
      appointment_relationship = changeset |> Repo.insert! |> Repo.preload(Q.preload_fields)
      render(conn, "show.json", appointment_relationship: appointment_relationship)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "appointment_relationship" => appointment_relationship_params}) do
    appointment_relationship = Repo.get!(AppointmentRelationship, id)
    changeset = AppointmentRelationship.changeset(appointment_relationship, appointment_relationship_params)

    if changeset.valid? do
      appointment_relationship = Repo.update!(changeset)
      render(conn, "show.json", appointment_relationship: appointment_relationship)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    appointment_relationship = Repo.get!(AppointmentRelationship, id)

    appointment_relationship = Repo.delete!(appointment_relationship) |> Repo.preload(Q.preload_fields)
    render(conn, "show.json", appointment_relationship: appointment_relationship)
  end
end
