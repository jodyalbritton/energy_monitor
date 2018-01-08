defmodule EnergyMonitor.Accounts.Device do
  use Ecto.Schema
  import Ecto.Changeset
  alias EnergyMonitor.Accounts.Device


  schema "devices" do
    field :device_id, :string
    field :label, :string
    field :location_id, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Device{} = device, attrs) do
    device
    |> cast(attrs, [:name, :label, :device_id, :location_id])
    |> validate_required([:name, :label, :device_id, :location_id])
  end
end
