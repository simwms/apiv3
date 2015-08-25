defmodule Apiv3.AppointmentRelationshipControllerTest do
  use Apiv3.SessionConnCase
  alias Apiv3.Appointment

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
    [dropoff|_] = account |> assoc(:appointments) |> Repo.all
    params = %{
      "notes" => "dogs are fun",
      "dropoff_id" => dropoff.id,
      "pickup_id" => pickup.id
    }
    path = conn |> appointment_relationship_path(:create)
    %{"appointment_relationship" => relationship} = conn
    |> post(path, appointment_relationship: params)
    |> json_response(200)

    assert relationship
    assert relationship["id"]
    assert relationship["dropoff_id"] == dropoff.id
    assert relationship["pickup_id"] == pickup.id
    assert relationship["account_id"] == account.id
  end

  test "it should index", %{conn: conn, account: account} do
    path = conn |> appointment_relationship_path(:index)
    response = conn
    |> get(path, %{"dropoff_id" => 1942})
    |> json_response(200)

    assert response == %{"appointment_relationships" => [], "appointments" => []}
  end
end