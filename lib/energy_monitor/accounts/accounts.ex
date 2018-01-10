defmodule EnergyMonitor.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias EnergyMonitor.Repo

  alias EnergyMonitor.Accounts.Connector
  alias EnergyMonitor.Accounts.Device

  @doc """
  Returns the list of connectors.

  ## Examples

      iex> list_connectors()
      [%Connector{}, ...]

  """
  def list_connectors do
    Repo.all(Connector)
  end

  @doc """
  Gets a single connector.

  Raises `Ecto.NoResultsError` if the Connector does not exist.

  ## Examples

      iex> get_connector!(123)
      %Connector{}

      iex> get_connector!(456)
      ** (Ecto.NoResultsError)

  """
  def get_connector!(id), do: Repo.get!(Connector, id)

  @doc """
  Creates a connector.

  ## Examples

      iex> create_connector(%{field: value})
      {:ok, %Connector{}}

      iex> create_connector(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_connector(attrs \\ %{}) do
    %Connector{}
    |> Connector.changeset(attrs)
    |> create_smartapp
    |> Repo.insert()

  end

  @doc """
  Updates a connector.

  ## Examples

      iex> update_connector(connector, %{field: new_value})
      {:ok, %Connector{}}

      iex> update_connector(connector, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_connector(%Connector{} = connector, attrs) do

    update_smartapp(connector)
    connector
    |> Connector.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Connector.

  ## Examples

      iex> delete_connector(connector)
      {:ok, %Connector{}}

      iex> delete_connector(connector)
      {:error, %Ecto.Changeset{}}

  """
  def delete_connector(%Connector{} = connector) do
    delete_smartapp(connector)
    Repo.delete(connector)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking connector changes.

  ## Examples

      iex> change_connector(connector)
      %Ecto.Changeset{source: %Connector{}}

  """
  def change_connector(%Connector{} = connector) do
    Connector.changeset(connector, %{})
  end



  @doc """
  Returns the list of devices.

  ## Examples

      iex> list_devices()
      [%Device{}, ...]

  """
  def list_devices do
    Repo.all(Device)
  end


  @doc """
  Import Devices from SmartThings
  """
  def import_devices do
    connections = list_connectors()
    for connector <- connections do
      client = Stex.connect(connector.access_token)
      devices = Stex.Devices.list(client) |> Stex.Devices.filter_devices_by_capability("energyMeter")

      for device <- devices do
        new_device = %{
          name: device.name,
          label: device.label,
          device_id: device.deviceId,
          location_id: device.locationId

        }

        create_or_update_device(new_device)
      end

    end
  end

  @doc """
  Gets a single device.

  Raises `Ecto.NoResultsError` if the Device does not exist.

  ## Examples

      iex> get_device!(123)
      %Device{}

      iex> get_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device!(id), do: Repo.get!(Device, id)

  @doc """
  Creates a device.

  ## Examples

      iex> create_device(%{field: value})
      {:ok, %Device{}}

      iex> create_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device(attrs \\ %{}) do
    %Device{}
    |> Device.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Creates OR updates a Provider if none exists.
  ## Examples
    iex> create_or_update_provider(%{field: value})
    {:ok, %Provider{}}
    iex> create_or_update_provider(%{field: bad_value})
    {:error, %Ecto.Changeset{}}
  """
  def create_or_update_device(target) do
    result =
  	case Repo.get_by(Device, device_id: target.device_id) do
      nil -> Device.changeset(%Device{}, target)
      device -> Device.changeset(device, target)
  	end
    result
  	|> Repo.insert_or_update
  end

  @doc """
  Updates a device.

  ## Examples

      iex> update_device(device, %{field: new_value})
      {:ok, %Device{}}

      iex> update_device(device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Device.

  ## Examples

      iex> delete_device(device)
      {:ok, %Device{}}

      iex> delete_device(device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device changes.

  ## Examples

      iex> change_device(device)
      %Ecto.Changeset{source: %Device{}}
a
  """
  def change_device(%Device{} = device) do
    Device.changeset(device, %{})
  end


  @doc """
  Create the smartapp for the connector
  """
  def create_smartapp(connector) do
    client = Stex.connect(connector.changes.access_token)
    new_app = Stex.Apps.createWebhookSmartApp(
      client,
      connector.changes.app_name,
      connector.changes.display_name,
      connector.changes.description,
      connector.changes.target_url
      )
    IO.inspect new_app

    Stex.Apps.set_auth_scopes(client, new_app.app)

    connector
    |> Ecto.Changeset.put_change(:rsa_pub, new_app.app.webhookSmartApp.publicKey)
    |> Ecto.Changeset.put_change(:app_id, new_app.app.appId)



  end


  def update_smartapp(connector) do
    client = Stex.connect(connector.access_token)
    Stex.Apps.updateWebhookSmartApp(client, connector)
  end


  def delete_smartapp(connector) do
    IO.puts "deleting SmartApp"
    IO.inspect connector
    if connector.app_id do
      client = Stex.connect(connector.access_token)
      Stex.Apps.delete(client, connector.app_id)
    end
  end
end
