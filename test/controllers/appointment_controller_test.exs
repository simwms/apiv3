defmodule Apiv3.AppointmentControllerTest do
  use Apiv3.SessionConnCase

  @appointment_attr %{
    appointment_type: "dropoff",
    company: "some content", 
    expected_at: "2015-08-21T15:09:38-07:00", 
    material_description: "horse poop", 
    notes: "some content"}
  
  setup do
    {account, conn} = account_session_conn()
    {:ok, conn: conn, account: account}
  end

  test "there should be two appointments in the fixture", %{account: account} do
    appointments = account |> assoc(:appointments) |> Repo.all
    assert Enum.count(appointments) == 2
    [a1, a2] = appointments
    assert a1.account_id == account.id
    assert a2.account_id == account.id
  end

  test "it should index the appointments correctly", %{conn: conn, account: account} do
    path = conn |> appointment_path(:index)
    response = conn
    |> get(path, %{})
    |> json_response(200)

    appointments = response["appointments"]
    assert Enum.count(appointments) == 2

    [a1, a2] = appointments
    assert a1["account_id"] == account.id
    assert a2["account_id"] == account.id

    meta = response["meta"]
    assert meta == %{"count" => 2, "total_pages" => 1, "current_page" => 1, "per_page" => 10}

    response = conn
    |> get(path, %{"expected_at_start" => "2015-08-21T15:09:38-07:00"})
    |> json_response(200)

    assert response["appointments"] == []
  end

  test "it should forbid cross-account access", %{conn: conn} do
    {account, _} = build_account
    [appointment|_] = assoc(account, :appointments) |> Repo.all

    path = conn |> appointment_path(:show, appointment.id)
    response = conn
    |> get(path, %{})
    |> json_response(403)

    assert response == %{"error" => "not authorized"}
  end

  test "it should show an appointment correctly", %{conn: conn, account: account} do
    [appointment|_] = account |> assoc(:appointments) |> Repo.all
    path = conn |> appointment_path(:show, appointment.id)
    response = conn
    |> get(path, %{})
    |> json_response(200)
    appt = response["appointment"]
    assert appt["id"] == appointment.id
    assert appt["account_id"] == account.id
    assert appt["permalink"] == appointment.permalink
  end

  
  test "it should properly create an appointment", %{conn: conn, account: account} do
    path = conn |> appointment_path(:create)
    response = conn
    |> post(path, appointment: @appointment_attr)
    |> json_response(200)

    appointment = response["appointment"]
    assert appointment["id"]
    assert appointment["permalink"]
    assert appointment["material_description"] == @appointment_attr[:material_description]
    assert appointment["account_id"] == account.id
  end

  test "it should allow proper updates to the appointment", %{conn: conn, account: account} do
    [appointment|_] = assoc(account, :appointments) |> Repo.all
    path = conn |> appointment_path(:update, appointment.id)
    response = conn
    |> put(path, appointment: @appointment_attr)
    |> json_response(200)
    actual = response["appointment"]
    assert actual["id"]  == appointment.id
    assert actual["material_description"] == "horse poop"
  end

  test "it should properly delete", %{conn: conn, account: account} do
    [appointment|_] = assoc(account, :appointments) |> Repo.all
    path = conn |> appointment_path(:delete, appointment.id)
    response = conn
    |> delete(path, %{})
    |> json_response(200)
    refute Repo.get(Apiv3.Appointment, appointment.id)
  end
end