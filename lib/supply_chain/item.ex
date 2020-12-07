defmodule SupplyChain.Item do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias SupplyChain.{Item, Chain, Participater}
  alias SupplyChain.Repo

  schema "item" do
    field :last_item_id, :integer
    field :level_on_chain, :integer
    field :portion, :float
    field :role, :string
    field :is_signed, :boolean, default: false

    belongs_to(:chain, Chain)
    belongs_to(:participater, Participater)
    timestamps()
  end

  def preload(item) do
    Repo.preload(item, [:chain, :participater])
  end

  def get_by_participater_id(id) do
    Item
    |> where([i], i.participater_id == ^id)
    |> SupplyChain.Repo.all()
  end

  def get_by_id(id) do
    Repo.get_by(Item, id: id)
  end

  def create(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def change(%Item{} = item) do
    Item.changeset(item, %{})
  end

  def changeset(%Item{} = item) do
    changeset(%Item{} = item, %{})
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:last_item_id, :chain_id, :participater_id, :level_on_chain, :portion, :role])
  end
end
