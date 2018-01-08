defmodule EnergyMonitorWeb.Router do
  use EnergyMonitorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EnergyMonitorWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index


    resources "/connectors", ConnectorController
    resources "/devices", DeviceController
  end


  scope "/api", EnergyMonitorWeb do
     pipe_through :api

     post "/smartapp", SmartAppController, :index
  end
end
