defmodule Apiv3.ReportQuery do
  import Ecto.Query
  alias Apiv3.Appointment
  alias Apiv3.Batch
  alias Apiv3.AppointmentQuery
  alias Apiv3.BatchQuery

  @default_appointment_query from a in Appointment,
    select: a,
    preload: [
      outgoing_batches: [:warehouse, :appointment],
      batches: [:warehouse, :appointment]
    ]
  def default_appointment_query(%{id: id}) do
    @default_appointment_query |> where([a], a.account_id == ^id)
  end

  def appointments(params, account) do
    default_appointment_query(account)
    |> consider_start_finish_dates(params)
  end

  def consider_start_finish_dates(query, %{"start_at" => start_at, "finish_at" => finish_at}) do
    query
    |> AppointmentQuery.expected_at_start(start_at)
    |> AppointmentQuery.expected_at_finish(finish_at)
  end
  def consider_start_finish_dates(query, _), do: query
end