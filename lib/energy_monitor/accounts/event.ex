defmodule EnergyMonitor.Accounts.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias EnergyMonitor.Accounts.Event


  schema "events" do
    field :attribute, :string
    field :capability, :string
    field :device_uuid, :string
    field :event_id, :string
    field :location_id, :string
    field :state_change, :boolean, default: false
    field :value, :float

    belongs_to :device, EnergyMonitor.Accounts.Device

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:device_uuid, :state_change, :event_id, :value, :capability, :attribute, :location_id])
    |> validate_required([:device_uuid, :state_change, :event_id, :value, :capability, :attribute, :location_id])
  end
end
