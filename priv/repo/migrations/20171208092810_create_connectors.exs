defmodule EnergyMonitor.Repo.Migrations.CreateConnectors do
  use Ecto.Migration

  def change do
    create table(:connectors) do
      add :access_token, :string

      timestamps()
    end

  end
end
