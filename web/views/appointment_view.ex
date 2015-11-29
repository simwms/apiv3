defmodule Apiv3.AppointmentView do
  use Apiv3.Web, :view
  # def render("index.json", %{appointments: appointments, meta: meta}) do
  #   %{
  #     appointments: render_many(appointments, "appointment.json"),
  #     trucks: render_trucks(appointments),
  #     weightickets: render_weightickets(appointments),
  #     batches: render_batches(appointments),
  #     meta: meta
  #   }
  # end

  # def render("show.json", %{appointment: appointment}) do
  #   %{
  #     appointment: render_one(appointment, "appointment.json"),
  #     trucks: render_trucks([appointment]),
  #     batches: render_batches([appointment]),
  #     weightickets: render_weightickets([appointment])
  #   }
  # end

  # def render("appointment.json", %{appointment: appointment}) do
  #   appointment |> ember_attributes |> reject_blank_keys
  # end

  # def render_batches(appointments) do
  #   incoming_batches = appointments
  #   |> Enum.flat_map(fn appointment -> appointment.batches end)

  #   outgoing_batches = appointments
  #   |> Enum.flat_map(fn appointment -> appointment.outgoing_batches end)

  #   (incoming_batches ++ outgoing_batches)
  #   |> Enum.reject(&is_nil/1)
  #   |> render_many("batch.json")
  # end

  # def render_trucks(appointments) do 
  #   appointments
  #   |> Enum.map(fn appointment -> appointment.truck end)
  #   |> Enum.reject(&is_nil/1)
  #   |> render_many("truck.json")
  # end

  # def render_weightickets(appointments) do
  #   appointments
  #   |> Enum.map(fn appointment -> appointment.weighticket end) 
  #   |> Enum.reject(&is_nil/1)
  #   |> render_many("weighticket.json")
  # end

  # defp ember_attributes(appointment) do
  #   import Fox.RecordExt, only: [just_ids: 1]
  #   %{
  #     id: appointment.id,
  #     permalink: appointment.permalink,
  #     appointment_type: appointment.appointment_type,
  #     company_permalink: appointment.company_permalink,
  #     created_at: appointment.inserted_at,
  #     updated_at: appointment.updated_at,
  #     expected_at: appointment.expected_at,
  #     fulfilled_at: appointment.fulfilled_at,
  #     cancelled_at: appointment.cancelled_at,
  #     exploded_at: appointment.exploded_at,
  #     consumed_at: appointment.consumed_at,
  #     coupled_at: appointment.coupled_at,
  #     material_description: appointment.material_description,
  #     company: appointment.company,
  #     notes: appointment.notes,
  #     external_reference: appointment.external_reference,
  #     batches: just_ids(appointment.batches),
  #     outgoing_batches: just_ids(appointment.outgoing_batches),
  #     dropoffs: just_ids(appointment.dropoffs),
  #     pickups: just_ids(appointment.pickups),
  #     account_id: appointment.account_id
  #   }
  # end
  @attributes ~w(permalink appointment_type 
    company_permalink created_at updated_at expected_at
    fulfilled_at cancelled_at exploded_at consumed_at
    coupled_at material_description company notes external_reference)a
  @relationships ~w(batches outgoing_batches dropoffs pickups account)a
  use Apiv3.JsViewConvention
end