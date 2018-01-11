defmodule EnergyMonitor.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias EnergyMonitor.Repo

  alias EnergyMonitor.Accounts.Connector
  alias EnergyMonitor.Accounts.Device
    alias EnergyMonitor.Accounts.Event

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
  def import_devices(access_token, devices) do
      client = Stex.connect(access_token)

      for device <- devices do
        device = Stex.Devices.show(client, device["deviceConfig"]["deviceId"])
        new_device = %{
          name: device.device.name,
          label: device.device.label,
          device_id: device.device.deviceId,
          location_id: device.device.locationId

        }

        create_or_update_device(new_device)
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


  @doc """
  Create Subscriptions
  """
  def create_app_subscriptions(access_token, app_id, devices) do
    client = Stex.connect(access_token)

    for device <- devices do
      Stex.Subscriptions.createSubscription(
        client,
        app_id,
        device["deviceConfig"]["deviceId"],
        "main",
        "energyMeter",
        "energy",
        false,
        "*"
        )
    end

  end

  @doc """
  Update an installed smartapp
  """
  def update_smartapp(connector) do
    client = Stex.connect(connector.access_token)
    Stex.Apps.updateWebhookSmartApp(client, connector)
  end

  @doc """
  Delete installapps subscriptions
  """
  def delete_app_subscriptions(access_token, app_id) do
    client = Stex.connect(access_token)
    Stex.Subscriptions.deleteSubscriptions(client, app_id)
  end

  def delete_smartapp(connector) do
    IO.puts "deleting SmartApp"
    IO.inspect connector
    if connector.app_id do
      client = Stex.connect(connector.access_token)
      Stex.Apps.delete(client, connector.app_id)
    end
  end



  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end
end
