defmodule SupplyChain.Repo.Migrations.ChangeEvidence do
  use Ecto.Migration

  def change do
    alter table(:evidence) do
      add :tx_id, :string
    end
  end
end
