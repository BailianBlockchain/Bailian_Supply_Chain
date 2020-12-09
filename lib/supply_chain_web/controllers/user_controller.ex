defmodule SupplyChainWeb.UserController do
  use SupplyChainWeb, :controller
  alias SupplyChain.User
  alias Decimal,as: D

  def new(conn, _params) do
    changeset = User.change(%User{})
    render(conn, "sign_up.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params, "participater" => participater_params}) do
    case User.create(user_params, participater_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Signed up successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "sign_up.html", changeset: changeset)
    end
  end

  def index(conn, sth) do
    user_id = get_session(conn, :current_user_id)
    if user_id do
      user =
        user_id
        |> User.get_by_user_id()
        |> User.preload()
      money =
        "#{user.participater.balance}"
        |> D.new()
        |> D.div(D.new("100"))
        |> D.to_float()
      render(
        conn,
        "user.html",
        %{
        login?: true,
        user: user,
        balance: money
        })
    else
      redirect(conn, to: Routes.user_path(conn, :new))
    end
  end
end
