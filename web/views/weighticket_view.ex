defmodule Apiv3.WeighticketView do
  use Apiv3.Web, :view
  
  def render("index.json", %{weightickets: weightickets}) do
    %{
      weightickets: render_many(weightickets, "weighticket.json"),
      appointments: render_appointments(weightickets),
      trucks: render_trucks(weightickets),
      pictures: render_pictures(weightickets)
    }
  end

  def render("show.json", %{weighticket: weighticket}) do
    %{
      weighticket: render_one(weighticket, "weighticket.json"),
      appointments: render_appointments([weighticket]),
      trucks: render_trucks([weighticket]),
      pictures: render_pictures([weighticket])
    }
  end

  def render("weighticket.json", %{weighticket: weighticket}) do
    weighticket |> ember_attributes |> reject_blank_keys
  end
  
  def render_trucks(weightickets) do
    weightickets
    |> Enum.map(fn weighticket -> weighticket.truck end)
    |> Enum.reject(&is_nil/1)
    |> render_many("truck.json")
  end

  def render_appointments(weightickets) do
    weightickets
    |> Enum.map(fn weighticket -> weighticket.appointment end)
    |> Enum.reject(&is_nil/1)
    |> render_many("appointment.json")
  end

  defdelegate render_pictures(weightickets), to: Apiv3.PictureView

  def ember_attributes(weighticket) do
    %{
      id: weighticket.id,
      appointment_id: weighticket.appointment_id,
      issuer_id: weighticket.issuer_id,
      finisher_id: weighticket.finisher_id,
      dock_id: weighticket.dock_id,
      truck_id: just_id(weighticket.truck),
      pounds: weighticket.pounds,
      license_plate: weighticket.license_plate,
      notes: weighticket.notes,
      finish_pounds: weighticket.finish_pounds,
      created_at: weighticket.inserted_at,
      updated_at: weighticket.updated_at,
      external_reference: weighticket.external_reference,
      pictures: just_ids(weighticket.pictures)
    }
  end
end
