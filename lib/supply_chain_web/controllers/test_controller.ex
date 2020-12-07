defmodule SupplyChainWeb.TestController do
  use SupplyChainWeb, :controller

  def index(conn, _params) do
    render(conn, "test.html")
  end
end
