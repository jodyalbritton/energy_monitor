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
      IO.puts "INSTALL PHASE"
      %{statusCode: 200, installData: %{}}
  end


  def render("update.json", params) do
      IO.puts "UPDATE PHASE"
      %{statusCode: 200, installData: %{}}
  end


  def render("uninstall.json", params) do
      IO.puts "UNINSTALL PHASE"
      %{statusCode: 200, installData: %{}}
  end


  def render("unhandled.json", params) do
    IO.puts "Unhandled lifecycle event"
    %{
      statusCode: 400
    }
  end

  def render("event.json", params) do
    IO.puts "Event Lifecycle"
    %{
      statusCode: 200
    }
  end

  def render("init.json", params) do
    IO.puts "LIFECYCLE PHASE: Config Init"

    %{
        statusCode: 200,
        configurationData: %{
          initialize: %{
            name: "ST Connector",
            description: "This and That",
            id: "app",
            permissions: [],
            firstPageId: "1"
          }
        }
    }
  end

  def render("page.json", params) do
    IO.puts "LIFECYCLE PHASE: Config Page"

    %{
        statusCode: 200,
        configurationData: %{
          page: %{
            pageId: "1",
            name: "Monitor These Energy Devices",
            nextPageId: "",
            previousPageId: "",
            complete: true,
            sections: [
              %{
                name: "Monitor These",
                settings: [
                  %{
                    id: "energyMeter",
                    name: "Which Energy Meters",
                    description: "Tap to set...",
                    type: "DEVICE",
                    required: false,
                    multiple: true,
                    capabilities: [
                      "energyMeter"
                    ],
                    permissions: [
                      "r"
                    ]
                  }
                ]
              }
            ]
          }
        }
    }
  end

  def render("undefinedLifeCycle.json", params) do
    IO.puts "Undefined Lifecycle"
    %{}
  end


end
