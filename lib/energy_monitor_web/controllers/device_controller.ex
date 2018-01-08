defmodule EnergyMonitorWeb.DeviceController do
  use EnergyMonitorWeb, :controller

  alias EnergyMonitor.Accounts
  alias EnergyMonitor.Accounts.Device

  def index(conn, _params) do
    devices = Accounts.list_devices()
    render(conn, "index.html", devices: devices)
  end

  def new(conn, _params) do
    changeset = Accounts.change_device(%Device{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"device" => device_params}) do
    case Accounts.create_device(device_params) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device created successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    device = Accounts.get_device!(id)
    render(conn, "show.html", device: device)
  end

  def edit(conn, %{"id" => id}) do
    device = Accounts.get_device!(id)
    changeset = Accounts.change_device(device)
    render(conn, "edit.html", device: device, changeset: changeset)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    device = Accounts.get_device!(id)

    case Accounts.update_device(device, device_params) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device updated successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", device: device, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    device = Accounts.get_device!(id)
    {:ok, _device} = Accounts.delete_device(device)

    conn
    |> put_flash(:info, "Device deleted successfully.")
    |> redirect(to: device_path(conn, :index))
  end
end
