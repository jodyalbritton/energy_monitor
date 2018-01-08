defmodule EnergyMonitor.Accounts.Connector do
  use Ecto.Schema
  import Ecto.Changeset
  alias EnergyMonitor.Accounts.Connector


  schema "connectors" do
    field :app_name, :string
    field :display_name, :string
    field :access_token, :string
    field :rsa_pub, :string
    field :installed_at, :utc_datetime
    field :description, :string
    field :app_id, :string
    field :owner_id, :string
    field :created_date, :utc_datetime
    field :last_updated_date, :utc_datetime
    field :client_id, :string
    field :client_secret, :string
    field :target_url, :string

    timestamps()
  end

  @doc false
  def changeset(%Connector{} = connector, attrs) do
    connector
    |> cast(attrs, [
      :app_name,
      :display_name,
      :access_token,
      :rsa_pub,
      :installed_at,
      :description,
      :app_id,
      :owner_id,
      :created_date,
      :last_updated_date,
      :client_id,
      :client_secret,
      :target_url

    ])
    |> validate_required([:access_token])
  end
end
