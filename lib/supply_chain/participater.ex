defmodule SupplyChain.Participater do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias SupplyChain.{Participater, Chain, Item}
  alias SupplyChain.Repo

  schema "participater" do
    field :name, :string
    field :describe, :string
    field :did, :string
    has_many(:item, Item)
    timestamps()
  end

  def get_all() do
    Repo.all(Participater)
  end

  def preload(participater) do
    Repo.preload(participater, [:item])
  end

  def get_by_id(id) do
    Repo.get_by(Participater, id: id)
  end

  def get_by_name(name) do
    Participater
    |> where([p], p.name == ^name)
    |> Repo.one!()
  end

  def create(attrs \\ %{}) do
    %Participater{}
    |> Participater.changeset(attrs)
    |> Repo.insert()
  end

  def change(%Participater{} = participater) do
    Participater.changeset(participater, %{})
  end

  @doc false
  def changeset(%Participater{} = participater, attrs) do
    participater
    |> cast(attrs, [:name, :describe, :did])
  end
end
