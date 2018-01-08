defmodule EnergyMonitor.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string
      add :label, :string
      add :device_id, :string
      add :location_id, :string

      timestamps()
    end

  end
end
