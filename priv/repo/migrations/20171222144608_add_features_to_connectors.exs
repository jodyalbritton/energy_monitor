defmodule EnergyMonitor.Repo.Migrations.AddFeaturesToConnectors do
  use Ecto.Migration

  def change do
    alter table(:connectors) do
      add :app_name, :string
      add :display_name, :string
      add :rsa_pub, :string
      add :installed_at, :utc_datetime
      add :description, :string
    end
  end
end
