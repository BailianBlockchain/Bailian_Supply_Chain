defmodule SupplyChain.Evidence do
  use Ecto.Schema
  import Ecto.Changeset
  alias SupplyChain.{Evidence, Chain, Item, Contract}
  alias SupplyChain.Repo

  schema "evidence" do
    field :key, :string
    field :value, :string
    field :describe, :string
    field :tx_id, :string
    field :owners, {:array, :integer}
    belongs_to :contract, Contract
    timestamps()
  end

  # +--------------+
  # | database ops |
  # +--------------+

  def preload(evi) do
    Repo.preload(evi, :contract)
  end

  def get_by_key(key) do
    Repo.get_by(Evidence, key: key)
  end

  def create(attrs \\ %{}) do
    %Evidence{}
    |> Evidence.changeset(attrs)
    |> Repo.insert()
  end

  def changeset(%Evidence{} = evi) do
    Evidence.changeset(evi, %{})
  end

  @doc false
  def changeset(%Evidence{} = evi, attrs) do
    evi
    |> cast(attrs, [:key, :value, :describe, :contract_id, :tx_id, :owners])
  end
end
