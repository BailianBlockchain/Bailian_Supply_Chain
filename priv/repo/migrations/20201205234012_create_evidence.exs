defmodule SupplyChain.Repo.Migrations.CreateEvidence do
  use Ecto.Migration

  def change do
    create table(:evidence) do
      add :key, :string
      add :value, :string
      add :describe, :string
      add :contract_id, :integer
      add :owners, {:array, :integer}
      timestamps()
    end
  end
end
