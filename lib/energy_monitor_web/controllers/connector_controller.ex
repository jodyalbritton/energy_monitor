defmodule EnergyMonitorWeb.ConnectorController do
  use EnergyMonitorWeb, :controller

  alias EnergyMonitor.Accounts
  alias EnergyMonitor.Accounts.Connector

  def index(conn, _params) do
    connectors = Accounts.list_connectors()
    render(conn, "index.html", connectors: connectors)
  end

  def new(conn, _params) do
    changeset = Accounts.change_connector(%Connector{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"connector" => connector_params}) do
    case Accounts.create_connector(connector_params) do
      {:ok, connector} ->
        conn
        |> put_flash(:info, "Connector created successfully.")
        |> redirect(to: connector_path(conn, :show, connector))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    connector = Accounts.get_connector!(id)
    render(conn, "show.html", connector: connector)
  end

  def edit(conn, %{"id" => id}) do
    connector = Accounts.get_connector!(id)
    changeset = Accounts.change_connector(connector)
    render(conn, "edit.html", connector: connector, changeset: changeset)
  end

  def update(conn, %{"id" => id, "connector" => connector_params}) do
    connector = Accounts.get_connector!(id)

    case Accounts.update_connector(connector, connector_params) do
      {:ok, connector} ->
        conn
        |> put_flash(:info, "Connector updated successfully.")
        |> redirect(to: connector_path(conn, :show, connector))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", connector: connector, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    connector = Accounts.get_connector!(id)
    {:ok, _connector} = Accounts.delete_connector(connector)

    conn
    |> put_flash(:info, "Connector deleted successfully.")
    |> redirect(to: connector_path(conn, :index))
  end
end
