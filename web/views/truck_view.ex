defmodule Apiv3.TruckView do
  use Apiv3.Web, :view
  
  def render("index.json", %{trucks: trucks}) do
    %{
      trucks: render_many(trucks, "truck.json"),
      appointments: render_appointments(trucks),
      weightickets: render_weightickets(trucks),
      batches: render_batches(trucks)
    }
  end

  def render("show.json", %{truck: truck}) do
    %{
      truck: render_one(truck, "truck.json"),
      appointments: render_appointments([truck]),
      weightickets: render_weightickets([truck]),
      batches: render_batches([truck])
    }
  end

  def render("truck.json", %{truck: truck}) do
    truck |> ember_attributes |> reject_blank_keys
  end

  def render_batches(trucks) do
    trucks
    |> Enum.flat_map(fn truck -> truck.batches end)
    |> Enum.reject(&is_nil/1)
    |> render_many("batch.json")
  end

  def render_appointments(trucks) do
    trucks
    |> Enum.map(fn truck -> truck.appointment end)
    |> render_many("appointment.json")
  end

  def render_weightickets(trucks) do
    trucks
    |> Enum.map(fn truck -> truck.weighticket end)
    |> render_many("weighticket.json")
  end

  defp ember_attributes(truck) do
    %{
      id: truck.id,
      entry_scale_id: truck.entry_scale_id,
      exit_scale_id: truck.exit_scale_id,
      dock_id: truck.dock_id,
      appointment_id: truck.appointment_id,
      weighticket_id: truck.weighticket_id,
      account_id: truck.account_id,
      arrived_at: truck.arrived_at,
      departed_at: truck.departed_at,
      docked_at: truck.docked_at,
      undocked_at: truck.undocked_at,
      created_at: truck.inserted_at,
      updated_at: truck.updated_at,
      batches: just_ids(truck.batches)
    }
  end
end