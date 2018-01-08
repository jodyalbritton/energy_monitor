defmodule EnergyMonitor.Repo.Migrations.AddTargetUrlToConnectors do
  use Ecto.Migration

  def change do
    alter table(:connectors) do
      add :target_url, :string
    end
  end
end
