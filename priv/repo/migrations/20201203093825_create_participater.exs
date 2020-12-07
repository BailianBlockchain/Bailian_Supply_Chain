defmodule SupplyChain.Repo.Migrations.CreateParticipater do
  use Ecto.Migration

  def change do
    create table(:participater) do
      add :name, :string
      add :describe, :string
      add :did, :string
      timestamps()
    end
  end
end
