defmodule Apiv3.BatchRelationshipControllerTest do
  use Apiv3.SessionConnCase
  alias Apiv3.Appointment
  alias Apiv3.Batch
  @appointment_attr %{
    appointment_type: "pickup",
    company: "some content", 
    expected_at: "2015-08-21T15:09:38-07:00", 
    material_description: "horse poop", 
    notes: "some content"}

  setup do
    {account, conn} = account_session_conn()
    pickup = account
    |> build(:appointments)
    |> Appointment.changeset(@appointment_attr)
    |> Repo.insert!
    {:ok, conn: conn, account: account, pickup: pickup}
  end

  test "it should create", %{conn: conn, account: account, pickup: pickup} do
    [batch|_] = account |> assoc(:batches) |> Repo.all
    assert batch.outgoing_count == 0
    params = %{
      "notes" => "dogs are fun",
      "batch_id" => batch.id,
      "appointment_id" => pickup.id
    }
    path = conn |> batch_relationship_path(:create)
    %{"batch_relationship" => br} = conn
    |> post(path, batch_relationship: params)
    |> json_response(200)

    assert br
    assert br["id"]
    assert br["batch_id"] == batch.id
    assert br["appointment_id"] == pickup.id
    assert br["account_id"] == account.id

    batch = Repo.get!(Batch, batch.id)
    
    assert batch.outgoing_count == 1
  end
end