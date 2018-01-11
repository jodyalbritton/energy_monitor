defmodule EnergyMonitorWeb.EventView do
  use EnergyMonitorWeb, :view
  alias EnergyMonitorWeb.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      device_uuid: event.device_uuid,
      state_change: event.state_change,
      event_id: event.event_id,
      value: event.value,
      capability: event.capability,
      attribute: event.attribute,
      location_id: event.location_id}
  end
end
