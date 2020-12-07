defmodule SupplyChain.Repo.Migrations.ChangeContract do
  use Ecto.Migration

  def change do
    alter table(:contract) do
      add :chain_id, :integer
    end
  end
end
