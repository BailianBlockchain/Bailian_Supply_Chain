defmodule SupplyChain.Repo.Migrations.UpdateChain do
  use Ecto.Migration

  def change do
    alter table(:chain) do
      add :status, :string
    end
  end
end
