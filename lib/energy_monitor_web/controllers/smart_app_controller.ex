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
          IO.inspect params
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
          render conn, "update.json", params: params
        "UNINSTALL" ->
          render conn, "uninstall.json", params: params
        "EVENT" ->
          render conn, "event.json", params: params
        _ ->
          render conn, "unhandled.json", params: params
      end
  end





end
