defmodule EnergyMonitor.Repo.Migrations.ChangeFieldOnConnectors do
  use Ecto.Migration

  def change do
    alter table(:connectors) do
      modify :rsa_pub, :text
    end
  end
end
