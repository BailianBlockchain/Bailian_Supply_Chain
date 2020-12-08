defmodule SupplyChain.Repo.Migrations.UpdateParticipaterBalance do
  use Ecto.Migration

  def change do
    alter table :participater do
      add :balance, :integer
    end
  end
end
