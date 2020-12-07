defmodule SupplyChain.Chain do
  use Ecto.Schema
  import Ecto.Changeset
  alias SupplyChain.{Chain, Item}
  alias SupplyChain.Repo

  schema "chain" do
    field :title, :string
    field :abstract, :string
    field :status, :string
    has_many(:item, Item)
    timestamps()
  end

  def get_all_participater(chain) do
    chain
    |> preload()
    |> Map.get(:item)
    |> Enum.map(fn item ->
      item.participater
    end)
  end

  def get_all() do
    Repo.all(Chain)
  end

  def preload(chain) do
    Repo.preload(chain, item: :participater)
  end

  def get_by_title(title) when is_nil(title) do
    nil
  end

  def get_by_title(title) do
    Repo.get_by(Chain, title: title)
  end

  def get_by_id(id) do
    Repo.get_by(Chain, id: id)
  end

  def create(attrs \\ %{}) do
    %Chain{}
    |> Chain.changeset(attrs)
    |> Repo.insert()
  end

  def changeset(%Chain{} = chain) do
    Chain.changeset(chain, %{})
  end

  @doc false
  def changeset(%Chain{} = chain, attrs) do
    chain
    |> cast(attrs, [:title, :abstract, :status])
    |> validate_required([:title, :abstract])
  end
end
