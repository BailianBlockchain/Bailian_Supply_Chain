defmodule SupplyChain.Repo.Migrations.CreateContractAndUpdateItem do
  use Ecto.Migration

  def change do
    create table(:contract) do
      add :addr, :string
      add :type, :string
      add :describe, :string
      timestamps()
    end

    alter table(:item) do
      add :portion, :float
      add :role, :string
    end
  end
end
