defmodule EnergyMonitor.AccountsTest do
  use EnergyMonitor.DataCase

  alias EnergyMonitor.Accounts

  describe "connectors" do
    alias EnergyMonitor.Accounts.Connector

    @valid_attrs %{access_token: "some access_token"}
    @update_attrs %{access_token: "some updated access_token"}
    @invalid_attrs %{access_token: nil}

    def connector_fixture(attrs \\ %{}) do
      {:ok, connector} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_connector()

      connector
    end

    test "list_connectors/0 returns all connectors" do
      connector = connector_fixture()
      assert Accounts.list_connectors() == [connector]
    end

    test "get_connector!/1 returns the connector with given id" do
      connector = connector_fixture()
      assert Accounts.get_connector!(connector.id) == connector
    end

    test "create_connector/1 with valid data creates a connector" do
      assert {:ok, %Connector{} = connector} = Accounts.create_connector(@valid_attrs)
      assert connector.access_token == "some access_token"
    end

    test "create_connector/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_connector(@invalid_attrs)
    end

    test "update_connector/2 with valid data updates the connector" do
      connector = connector_fixture()
      assert {:ok, connector} = Accounts.update_connector(connector, @update_attrs)
      assert %Connector{} = connector
      assert connector.access_token == "some updated access_token"
    end

    test "update_connector/2 with invalid data returns error changeset" do
      connector = connector_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_connector(connector, @invalid_attrs)
      assert connector == Accounts.get_connector!(connector.id)
    end

    test "delete_connector/1 deletes the connector" do
      connector = connector_fixture()
      assert {:ok, %Connector{}} = Accounts.delete_connector(connector)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_connector!(connector.id) end
    end

    test "change_connector/1 returns a connector changeset" do
      connector = connector_fixture()
      assert %Ecto.Changeset{} = Accounts.change_connector(connector)
    end
  end

  describe "devices" do
    alias EnergyMonitor.Accounts.Device

    @valid_attrs %{device_id: "some device_id", label: "some label", location_id: "some location_id", name: "some name"}
    @update_attrs %{device_id: "some updated device_id", label: "some updated label", location_id: "some updated location_id", name: "some updated name"}
    @invalid_attrs %{device_id: nil, label: nil, location_id: nil, name: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Accounts.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Accounts.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = Accounts.create_device(@valid_attrs)
      assert device.device_id == "some device_id"
      assert device.label == "some label"
      assert device.location_id == "some location_id"
      assert device.name == "some name"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, device} = Accounts.update_device(device, @update_attrs)
      assert %Device{} = device
      assert device.device_id == "some updated device_id"
      assert device.label == "some updated label"
      assert device.location_id == "some updated location_id"
      assert device.name == "some updated name"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_device(device, @invalid_attrs)
      assert device == Accounts.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Accounts.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Accounts.change_device(device)
    end
  end
end
