defmodule Apiv3.ReportView do
  use Apiv3.Web, :view
  import Fox.IntegerExt
  defdelegate count(xs), to: Enum

  @attributes ~w(start_at finish_at)a
  
  def render("show.json", %{report: report}) do
    %{data: render_one(report, __MODULE__, "report.json")}
  end

  def render("report.json", %{report: report}) do
    %{
      id: report.id,
      type: "reports",
      attributes: report |> Map.take(@attributes) |> reject_blank_keys,
      relationships: %{ 
        account: %{
          data: %{ id: report |> Map.get(:account_id), type: "accounts"} 
        }
      } 
    }
  end

  def material_description(%{material_description: d}), do: d

  def storage_position(tile) do
    "#{tile.x}-#{tile.y}"
  end

  def appt_permalink(%{appointment: %{permalink: permalink}}) when is_binary(permalink) do
    permalink
  end
  def appt_permalink(_batch), do: "none"

  def fa_class("outgoing"), do: "fa-minus"
  def fa_class("incoming"), do: "fa-plus"
  def fa_class(_), do: "fa-question-circle"

  @spec batches([Apiv3.Appointment]) :: [{Apiv3.Batch, String.t}]
  def batches(appointments) when is_list(appointments) do
    appointments
    |> Enum.flat_map(&batches/1)
    |> Enum.sort(fn {b1, _}, {b2, _} -> b1.id < b2.id end)
  end
  def batches(%{batches: i_batches, outgoing_batches: o_batches}) do
    xs = i_batches |> Enum.map(&({&1, "incoming"}))
    ys = o_batches |> Enum.map(&({&1, "outgoing"}))
    xs ++ ys
  end

  def appointment_type(%{appointment_type: "dropoff"}), do: "+"
  def appointment_type(%{appointment_type: "pickup"}), do: "-"
  def appointment_type(%{appointment_type: "both"}), do: "+/-"
  def appointment_type(_), do: "?"

  def is_fulfilled?(%{fulfilled_at: nil}), do: false
  def is_fulfilled?(%{fulfilled_at: _}), do: true

  def is_cancelled?(%{cancelled_at: nil}), do: false
  def is_cancelled?(%{cancelled_at: _}), do: true

  def is_missing?(appt), do: "missing" == infer_status(appt)
  def is_problem?(appt), do: "problem" == infer_status(appt)
  def is_expected?(appt), do: "expected" == infer_status(appt)
  def is_planned?(appt), do: "planned" == infer_status(appt)
  def is_incoming?({_, "incoming"}), do: true
  def is_incoming?(_), do: false
  def is_outgoing?({_, "outgoing"}), do: true
  def is_outgoing?(_), do: false

  def problem_filter(appointments), do: appointments |> Enum.filter(&is_problem?/1)
  def missing_filter(appointments), do: appointments |> Enum.filter(&is_missing?/1)
  def fulfiled_filter(appointments), do: appointments |> Enum.filter(&is_fulfilled?/1)
  def cancelled_filter(appointments), do: appointments |> Enum.filter(&is_cancelled?/1)
  def ongoing_filter(appointments), do: appointments |> Enum.filter(&is_expected?/1)
  def planned_filter(appointments), do: appointments |> Enum.filter(&is_planned?/1)
  def incoming_batches(appointments), do: appointments |> batches |> Enum.filter(&is_incoming?/1)
  def outgoing_batches(appointments), do: appointments |> batches |> Enum.filter(&is_outgoing?/1)

  def infer_status(appt) do
    cond do
      appt.fulfilled_at -> "fulfilled"
      appt.cancelled_at -> "cancelled"
      appt.exploded_at -> "problem"
      is_nil(appt.expected_at) -> "problem"
      appt.expected_at < Timex.Date.local -> "missing"
      appt.expected_at > Timex.Date.local -> "planned"
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
