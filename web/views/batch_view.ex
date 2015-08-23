defmodule Apiv3.BatchView do
  use Apiv3.Web, :view

  def render("index.json", %{batches: batches}) do
    %{
      batches: render_many(batches, "batch.json"),
      trucks: render_trucks(batches),
      appointments: render_appointments(batches),
      pictures: render_pictures(batches)
    }
  end

  def render("show.json", %{batch: batch}) do
    %{
      batch: render_one(batch, "batch.json"),
      trucks: render_trucks([batch]),
      appointments: render_appointments([batch]),
      pictures: render_pictures([batch])
    }
  end

  def render("batch.json", %{batch: batch}) do
    batch |> ember_attributes |> reject_blank_keys
  end

  defdelegate render_pictures(batch), to: Apiv3.PictureView

  def render_trucks(batches) do
    batches
    |> Enum.map(fn batch -> batch.truck end)
    |> Enum.reject(&is_nil/1)
    |> render_many("truck.json")
  end
  
  def render_appointments(batches) do
    dropoff_appointments = batches 
    |> Enum.map(fn batch -> batch.appointment end)
    |> Enum.reject(&is_nil/1)

    pickup_appointments = batches
    |> Enum.flat_map(fn batch -> batch.pickup_appointments end)
    |> Enum.reject(&is_nil/1)

    (dropoff_appointments ++ pickup_appointments)
    |> render_many("appointment.json")
  end

  defp ember_attributes(batch) do
    %{id: batch.id,
      permalink: batch.permalink,
      description: batch.description,
      quantity: batch.quantity,
      deleted_at: batch.deleted_at,
      dock_id: batch.dock_id,
      truck_id: batch.truck_id,
      account_id: batch.account_id,
      appointment_id: batch.appointment_id,
      warehouse_id: batch.warehouse_id,
      outgoing_count: batch.outgoing_count,
      created_at: batch.inserted_at,
      updated_at: batch.updated_at,
      pickup_appointments: just_ids(batch.pickup_appointments),
      pictures: just_ids(batch.pictures)}
  end
end
