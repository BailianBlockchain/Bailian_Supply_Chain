defmodule SupplyChainWeb.UserController do
  use SupplyChainWeb, :controller
  alias SupplyChain.User

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

  def index(conn, _) do
    if get_session(conn, :current_user_id) do
      render(conn, "user.html", payload: %{login?: true})
    else
      redirect(conn, to: Routes.user_path(conn, :new))
    end
  end
end
