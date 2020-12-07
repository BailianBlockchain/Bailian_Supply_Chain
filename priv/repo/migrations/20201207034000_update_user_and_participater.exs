defmodule SupplyChain.Repo.Migrations.UpdateUserAndParticipater do
  use Ecto.Migration

  def change do
    alter table :user do
      add :participater_id, :integer
    end
    alter table :participater do
      add :user_id, :integer
    end
  end
end
