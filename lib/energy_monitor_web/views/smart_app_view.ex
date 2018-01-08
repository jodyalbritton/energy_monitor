defmodule EnergyMonitorWeb.SmartAppView do
  use EnergyMonitorWeb, :view


  def render("ping.json", params) do
    %{
      statusCode: 200,
      pingData: %{
        challenge: params.conn.assigns.params["pingData"]["challenge"]
      }
    }
  end

  def render("install.json", params) do
      %{}
  end


  def render("unhandled.json", params) do
    IO.puts "Unhandled lifecycle event"
    %{
      statusCode: 400
    }
  end


  def render("configure.json", params) do
    %{
      name: "ST Connector",
      description: "This is a sample",
      id: "App",
      firstPageId: "1"

    }
  end


end
