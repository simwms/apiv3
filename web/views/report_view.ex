defmodule Apiv3.ReportView do
  use Apiv3.Web, :view
  import Fox.IntegerExt
  defdelegate count(xs), to: Enum

  def material_description(%{material_description: d}), do: d

  def storage_position(tile) do
    "#{alphabetize(tile.x)}-#{tile.y}"
  end

  def batch_type(%{batch_type: "incoming"}), do: "+"
  def batch_type(%{batch_type: "outgoing"}), do: "-"
  def batch_type(%{batch_type: "split"}), do: "/"

  def appointment_type(%{appointment_type: "dropoff"}), do: "+"
  def appointment_type(%{appointment_type: "pickup"}), do: "-"
  def appointment_type(%{appointment_type: "both"}), do: "+/-"

  def is_fulfilled?(%{fulfilled_at: nil}), do: false
  def is_fulfilled?(%{fulfilled_at: _}), do: true

  def is_cancelled?(%{cancelled_at: nil}), do: false
  def is_cancelled?(%{cancelled_at: _}), do: true

  def is_missing?(appt), do: "missing" == infer_status(appt)
  def is_problem?(appt), do: "problem" == infer_status(appt)
  def is_expected?(appt), do: "expected" == infer_status(appt)
  def is_planned?(appt), do: "planned" == infer_status(appt)
  def is_incoming?(batch), do: "incoming" == batch.batch_type
  def is_outgoing?(batch), do: "outgoing" == batch.batch_type

  def problem_filter(appointments), do: appointments |> Enum.filter(&is_problem?/1)
  def missing_filter(appointments), do: appointments |> Enum.filter(&is_missing?/1)
  def fulfiled_filter(appointments), do: appointments |> Enum.filter(&is_fulfilled?/1)
  def cancelled_filter(appointments), do: appointments |> Enum.filter(&is_cancelled?/1)
  def ongoing_filter(appointments), do: appointments |> Enum.filter(&is_expected?/1)
  def planned_filter(appointments), do: appointments |> Enum.filter(&is_planned?/1)
  def incoming_filter(batches), do: batches |> Enum.filter(&is_incoming?/1)
  def outgoing_filter(batches), do: batches |> Enum.filter(&is_outgoing?/1)

  def infer_status(appt) do
    cond do
      appt.fulfilled_at -> "fulfilled"
      appt.cancelled_at -> "cancelled"
      appt.exploded_at -> "problem"
      is_nil(appt.expected_at) -> "problem"
      appt.expected_at < Ecto.DateTime.utc -> "missing"
      appt.expected_at > Ecto.DateTime.utc -> "planned"
      true -> "expected"
    end
  end

  def infer_status_message(appt) do
    case infer_status(appt) do
      "fulfilled" -> "fulfilled on #{appt.fulfilled_at}"
      "cancelled" -> "cancelled on #{appt.cancelled_at}"
      "problem" -> 
        if appt.exploded_at do
          "problem occured on #{appt.exploded_at}"
        else
          "problem - missing date"
        end
      "missing" -> "missing since #{appt.expected_at}"
      "planned" -> "planned for #{appt.expected_at}"
      "expected" -> "expected at #{appt.expected_at}"
    end
  end
end
