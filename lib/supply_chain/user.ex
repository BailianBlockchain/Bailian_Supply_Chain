defmodule SupplyChain.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
  alias SupplyChain.{User, Participater, Did, }
  alias SupplyChain.Repo

  schema "user" do
    field :encrypted_password, :string
    field :username, :string
    belongs_to :participater, Participater
    timestamps()
  end

  def preload(user) do
    Repo.preload(user, :participater)
  end
  def get_all() do
    Repo.all(User)
  end

  def get_by_username(username) when is_nil(username) do
    nil
  end

  def get_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def get_by_userid(id) do
    Repo.get_by(User, id: id)
  end

  def create(user_params, participater_params) do
    {:ok, user} = create(user_params)

    {:ok, participater} =
    participater_params
    |> StructTranslater.to_atom_struct()
    |> Map.put(:user_id, user.id)
    |> Participater.create()

    %{priv: priv_bin} = SupplyChain.WeidCrypto.gen_keys()
    priv_hex = Base.encode16(priv_bin, case: :lower)
    # BUG: name cannot to long.
    {:ok, addr} = WeBaseInteractor.create_account(priv_hex, participater.name)
    did = Did.addr_to_did(addr)
    {:ok, participater} = Participater.update(participater, %{did: did})
    {:ok, user} = update(user, %{participater_id: participater.id})
    {:ok, preload(user)}
  end

  def create(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update(user, attrs) do
    user
    |> changeset(attrs)
    |> Repo.update
  end

  def change(%User{} = user) do
    User.changeset(user, %{})
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :encrypted_password, :participater_id])
    |> unique_constraint(:username)
    |> validate_required([:username, :encrypted_password])
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
