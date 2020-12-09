defmodule SupplyChain.Participater do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias SupplyChain.{Participater, Item, User}
  alias SupplyChain.Repo

  schema "participater" do
    field :name, :string
    field :name_on_webase, :string
    field :describe, :string
    field :did, :string
    field :balance, :integer, default: 0
    belongs_to :user, User
    has_many :item, Item
    timestamps()
  end

  def update(participater, attrs) do
    participater
    |> changeset(attrs)
    |> Repo.update
  end

  def get_all() do
    Repo.all(Participater)
  end

  def preload(participater) do
    Repo.preload(participater, [:item])
  end

  def get_by_did(did) do
    Repo.get_by(Participater, did: did)
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
    |> cast(attrs, [:name, :describe, :did, :user_id, :balance, :name_on_webase])
  end
end
