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
          render conn, "configure.json", params: params
        "INSTALL" ->
          render conn, "install.json", params: params
        "UPDATE" ->
          render conn, "index.json", params: params
        "UNINSTALL" ->
          render conn, "index.json", params: params
        "EVENT" ->
          render conn, "index.json", params: params
        _ ->
          render conn, "unhandled.json", params: params
      end
  end


end
