defmodule SupplyChainWeb.PageController do
  use SupplyChainWeb, :controller
  alias SupplyChain.CredentialVerifier, as: CredentialVerifier
  alias SupplyChain.WeidAdapter, as: WeidAdapter

  @payload %{
    name: "Super Supply Chain·基于区块链的供应链管理结算平台",
    slogan: "极速结算",
    credetialverifier: %CredentialVerifier{},
    changeset: nil,
    verify_result: nil
  }

  @doc """
    get action.
  """
  def index(conn, _params) do
    render(conn, "index.html", payload: @payload)
  end

end
