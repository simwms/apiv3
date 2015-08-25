defmodule Apiv3.BatchRelationshipView do
  use Apiv3.Web, :view

  def render("index.json", %{batch_relationships: batch_relationships}) do
    %{
      batch_relationships: render_many(batch_relationships, "batch_relationship.json"),
      appointments: render_appointments(batch_relationships),
      batches: render_batches(batch_relationships)
    }
  end

  def render("show.json", %{batch_relationship: batch_relationship}) do
    %{
      batch_relationship: render_one(batch_relationship, "batch_relationship.json"),
      appointments: render_appointments([batch_relationship]),
      batches: render_batches([batch_relationship])
    }
  end

  def render("batch_relationship.json", %{batch_relationship: batch_relationship}) do
    batch_relationship |> ember_attributes |> reject_blank_keys
  end

  def render_appointments(relationships) do
    relationships
    |> Enum.map(fn relationship -> relationship.appointment end)
    |> render_many("appointment.json")
  end
  def render_batches(relationships) do
    relationships
    |> Enum.map(fn relationship -> relationship.batch end)
    |> render_many("batch.json")
  end

  def ember_attributes(r) do
    %{
      id: r.id,
      batch_id: r.batch_id,
      appointment_id: r.appointment_id,
      account_id: r.account_id
    }
  end
end
