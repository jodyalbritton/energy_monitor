defmodule EnergyMonitor.Repo.Migrations.AddInstallIdToConnectors do
  use Ecto.Migration

  def change do
    alter table(:connectors) do
      add :app_id, :string
      add :owner_id, :string
      add :created_date, :utc_datetime
      add :last_updated_date, :utc_datetime
      add :client_id, :string
      add :client_secret, :string
    end
  end
end
