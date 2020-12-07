defmodule SupplyChain.Repo.Migrations.CreateChain do
  use Ecto.Migration

  def change do
    create table(:chain) do
      add :title, :string
      add :abstract, :string
      timestamps()
    end
  end
end
