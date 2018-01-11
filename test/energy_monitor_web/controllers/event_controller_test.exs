defmodule EnergyMonitorWeb.EventControllerTest do
  use EnergyMonitorWeb.ConnCase

  alias EnergyMonitor.Accounts
  alias EnergyMonitor.Accounts.Event

  @create_attrs %{attribute: "some attribute", capability: "some capability", device_uuid: "some device_uuid", event_id: "some event_id", location_id: "some location_id", state_change: true, value: 120.5}
  @update_attrs %{attribute: "some updated attribute", capability: "some updated capability", device_uuid: "some updated device_uuid", event_id: "some updated event_id", location_id: "some updated location_id", state_change: false, value: 456.7}
  @invalid_attrs %{attribute: nil, capability: nil, device_uuid: nil, event_id: nil, location_id: nil, state_change: nil, value: nil}

  def fixture(:event) do
    {:ok, event} = Accounts.create_event(@create_attrs)
    event
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get conn, event_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "attribute" => "some attribute",
        "capability" => "some capability",
        "device_uuid" => "some device_uuid",
        "event_id" => "some event_id",
        "location_id" => "some location_id",
        "state_change" => true,
        "value" => 120.5}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "attribute" => "some updated attribute",
        "capability" => "some updated capability",
        "device_uuid" => "some updated device_uuid",
        "event_id" => "some updated event_id",
        "location_id" => "some updated location_id",
        "state_change" => false,
        "value" => 456.7}
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
