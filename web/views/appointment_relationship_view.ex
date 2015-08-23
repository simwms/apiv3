defmodule Apiv3.AppointmentRelationshipView do
  use Apiv3.Web, :view

  def render("index.json", %{appointment_relationships: appointment_relationships}) do
    %{
      appointment_relationships: render_many(appointment_relationships, "appointment_relationship.json"),
      appointments: render_appointments(appointment_relationships)
    }
  end

  def render("show.json", %{appointment_relationship: appointment_relationship}) do
    %{
      appointment_relationship: render_one(appointment_relationship, "appointment_relationship.json"),
      appointments: render_appointments([appointment_relationship])
    }
  end

  def render("appointment_relationship.json", %{appointment_relationship: appointment_relationship}) do
    appointment_relationship |> ember_attributes |> reject_blank_keys
  end

  def render_appointments(relationships) do
    pickups = relationships
    |> Enum.map(fn r -> r.pickup end)

    dropoffs = relationships
    |> Enum.map(fn r -> r.dropoff end)

    (pickups ++ dropoffs)
    |> Enum.reject(&is_nil/1)
    |> render_many("appointment.json")
  end

  def ember_attributes(ar) do
    %{id: ar.id,
      pickup_id: ar.pickup_id,
      dropoff_id: ar.dropoff_id,
      notes: ar.notes,
      created_at: ar.inserted_at,
      updated_at: ar.updated_at }
  end
end
