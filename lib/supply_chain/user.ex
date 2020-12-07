defmodule SupplyChain.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
  alias SupplyChain.User
  alias SupplyChain.Repo

  schema "user" do
    field :encrypted_password, :string
    field :username, :string
    timestamps()
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

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :encrypted_password])
    |> unique_constraint(:username)
    |> validate_required([:username, :encrypted_password])
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
