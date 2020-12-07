defmodule SupplyChain.Repo.Migrations.ChangeContractAddOwner do
  use Ecto.Migration

  def change do
    alter table(:contract) do
      add :owner_did, :string
    end
  end
end
