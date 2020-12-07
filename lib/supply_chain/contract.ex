defmodule SupplyChain.Contract do
  use Ecto.Schema
  import Ecto.Changeset
  alias SupplyChain.{Contract, Item, Chain, Evidence}
  alias SupplyChain.Repo

  schema "contract" do
    field :addr, :string
    field :type, :string
    field :describe, :string
    field :owner_did, :string
    has_one :evidence, Evidence
    belongs_to :chain, Chain
    timestamps()
  end

  def get_by_addr(addr) do
    Repo.get_by(Contract, addr: addr)
  end

  def create(attrs \\ %{}) do
    %Contract{}
    |> Contract.changeset(attrs)
    |> Repo.insert()
  end

  def changeset(%Contract{} = contract) do
    Contract.changeset(contract, %{})
  end

  @doc false
  def changeset(%Contract{} = contract, attrs) do
    contract
    |> cast(attrs, [:addr, :type, :describe, :chain_id, :owner_did])
  end
end
