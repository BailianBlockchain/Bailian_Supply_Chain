defmodule SupplyChainWeb.CredentialController do
  use SupplyChainWeb, :controller

  def index(conn, params) do
    IO.puts(inspect(params))
    json(conn, %{ok: "ok"})
  end
end
