defmodule SupplyChain.Repo.Migrations.ChangeItem do
  use Ecto.Migration

  def change do
    alter table(:item) do
      add :is_signed, :boolean
    end
  end
end
