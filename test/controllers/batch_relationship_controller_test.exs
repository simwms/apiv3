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

  test "create and destroy", %{conn: conn, account: account, pickup: pickup} do
    [batch|_] = account |> assoc(:batches) |> Repo.all
    assert batch.outgoing_count == 0
    params = %{
      "notes" => "dogs are fun",
      "batch_id" => batch.id,
      "appointment_id" => pickup.id
    }
    path = conn |> batch_relationship_path(:create)
    %{"data" => br} = conn
    |> post(path, batch_relationship: params)
    |> json_response(200)

    assert br
    assert br["id"]
    assert br["type"] == "batch_relationships"
    rels = br["relationships"]
    assert rels["batch"]["data"]["id"] == batch.id
    assert rels["appointment"]["data"]["id"] == pickup.id
    assert rels["account"]["data"]["id"] == account.id

    batch = Repo.get!(Batch, batch.id)
    assert batch.outgoing_count == 1

    path = conn |> batch_relationship_path(:delete, br["id"])
    %{"data" => br} = conn
    |> delete(path, %{})
    |> json_response(200)

    assert br["id"]
    refute Repo.get(Apiv3.BatchRelationship, br["id"])

    batch = Repo.get!(Batch, batch.id)
    assert batch.outgoing_count == 0
  end

  test "index", %{conn: conn} do
    path = conn |> batch_relationship_path(:index)
    %{"data" => brs} = conn
    |> get(path, %{})
    |> json_response(200)

    assert Enum.count(brs) == 0
  end
end