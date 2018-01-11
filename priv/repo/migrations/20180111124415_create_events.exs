defmodule EnergyMonitor.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :device_uuid, :string
      add :state_change, :boolean, default: false, null: false
      add :event_id, :string
      add :value, :float
      add :capability, :string
      add :attribute, :string
      add :location_id, :string
      add :device_id, references(:devices, on_delete: :nothing)

      timestamps()
    end

    create index(:events, [:device_id])
  end
end
