defmodule SupplyChainWeb.Middleware.RequireAuth do
  alias SupplyChainWeb.Router.Helpers, as: Routes
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]

  def init(default), do: default

  def call(conn, _default) do
    if get_session(conn, :current_user_id) do
      conn
    else
      conn
      |> put_session(:redirect_to, conn.request_path)
      |> redirect(to: Routes.user_path(conn, :new))
      |> halt()
    end
  end
end
