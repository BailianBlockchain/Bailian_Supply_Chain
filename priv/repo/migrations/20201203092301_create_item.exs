defmodule SupplyChain.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:item) do
      add :chain_id, :integer
      add :last_item_id, :integer
      add :level_on_chain, :integer
      add :participater_id, :integer
      timestamps()
    end
  end
end
