defmodule SupplyChain.Repo.Migrations.UpdateParticipaterWithWebaseUser do
  use Ecto.Migration

  def change do
    alter table :participater do
      add :name_on_webase, :string
    end
  end
end
