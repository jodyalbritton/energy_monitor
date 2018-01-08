defmodule EnergyMonitorWeb.ConnectorControllerTest do
  use EnergyMonitorWeb.ConnCase

  alias EnergyMonitor.Accounts

  @create_attrs %{access_token: "some access_token"}
  @update_attrs %{access_token: "some updated access_token"}
  @invalid_attrs %{access_token: nil}

  def fixture(:connector) do
    {:ok, connector} = Accounts.create_connector(@create_attrs)
    connector
  end

  describe "index" do
    test "lists all connectors", %{conn: conn} do
      conn = get conn, connector_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Connectors"
    end
  end

  describe "new connector" do
    test "renders form", %{conn: conn} do
      conn = get conn, connector_path(conn, :new)
      assert html_response(conn, 200) =~ "New Connector"
    end
  end

  describe "create connector" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, connector_path(conn, :create), connector: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == connector_path(conn, :show, id)

      conn = get conn, connector_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Connector"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, connector_path(conn, :create), connector: @invalid_attrs
      assert html_response(conn, 200) =~ "New Connector"
    end
  end

  describe "edit connector" do
    setup [:create_connector]

    test "renders form for editing chosen connector", %{conn: conn, connector: connector} do
      conn = get conn, connector_path(conn, :edit, connector)
      assert html_response(conn, 200) =~ "Edit Connector"
    end
  end

  describe "update connector" do
    setup [:create_connector]

    test "redirects when data is valid", %{conn: conn, connector: connector} do
      conn = put conn, connector_path(conn, :update, connector), connector: @update_attrs
      assert redirected_to(conn) == connector_path(conn, :show, connector)

      conn = get conn, connector_path(conn, :show, connector)
      assert html_response(conn, 200) =~ "some updated access_token"
    end

    test "renders errors when data is invalid", %{conn: conn, connector: connector} do
      conn = put conn, connector_path(conn, :update, connector), connector: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Connector"
    end
  end

  describe "delete connector" do
    setup [:create_connector]

    test "deletes chosen connector", %{conn: conn, connector: connector} do
      conn = delete conn, connector_path(conn, :delete, connector)
      assert redirected_to(conn) == connector_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, connector_path(conn, :show, connector)
      end
    end
  end

  defp create_connector(_) do
    connector = fixture(:connector)
    {:ok, connector: connector}
  end
end
