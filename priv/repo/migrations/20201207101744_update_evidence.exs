defmodule SupplyChain.Repo.Migrations.UpdateEvidence do
  use Ecto.Migration

  def change do
    alter table :evidence do
      add :signers, {:array, :integer}
    end
  end
end
