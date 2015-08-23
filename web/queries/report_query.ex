defmodule Apiv3.ReportQuery do
  import Ecto.Query
  alias Apiv3.Appointment
  alias Apiv3.Batch
  alias Apiv3.AppointmentQuery
  alias Apiv3.BatchQuery

  @default_appointment_query from a in Appointment,
    select: a
  def appointments(params) do
    @default_appointment_query
    |> consider_start_finish_dates(params)
  end

  @default_batch_query from b in Batch,
    select: b,
    order_by: [desc: b.appointment_id, desc: b.inserted_at],
    preload: [:warehouse, :appointment]
  def batches(params) do
    @default_batch_query
    |> BatchQuery.created_at_start(params["start_at"])
    |> BatchQuery.created_at_finish(params["finish_at"])
  end

  def consider_start_finish_dates(query, %{"start_at" => start_at, "finish_at" => finish_at}) do
    query
    |> AppointmentQuery.expected_at_start(start_at)
    |> AppointmentQuery.expected_at_finish(finish_at)
  end
  def consider_start_finish_dates(query, _), do: query
end