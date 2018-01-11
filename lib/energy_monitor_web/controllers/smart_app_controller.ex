defmodule EnergyMonitorWeb.SmartAppController do
  use EnergyMonitorWeb, :controller

  def index(conn, params) do
      handle_request(conn, params)
  end



  def handle_request(conn, params) do

      case params["lifecycle"] do
        "PING" ->
          render conn, "ping.json", params: params
        "CONFIGURATION" ->
          case params["configurationData"]["phase"] do
            "INITIALIZE" ->
              render conn, "init.json", params: params
            "PAGE" ->
              render conn, "page.json", params: params
            _->
              render conn, "unhandled.json", params: params
          end
        "INSTALL" ->
          render conn, "install.json", params: params
        "UPDATE" ->
          update_devices(
            params["updateData"]["authToken"],
            params["updateData"]["installedApp"]["config"]["energyMeter"],
            params["updateData"]["installedApp"]["installedAppId"])

          render conn, "update.json", params: params
        "UNINSTALL" ->
          render conn, "uninstall.json", params: params
        "EVENT" ->
          IO.inspect params["eventData"]["events"]
          render conn, "event.json", params: params
        _ ->
          render conn, "unhandled.json", params: params
      end
  end


  def update_devices(access_token, devices, app_id) do
    EnergyMonitor.Accounts.delete_app_subscriptions(access_token, app_id)
    EnergyMonitor.Accounts.create_app_subscriptions(access_token, app_id, devices)
    EnergyMonitor.Accounts.import_devices(access_token, devices)
  end






end
