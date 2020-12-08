defmodule SupplyChain.Erc20Handler do
  @moduledoc """
    handle with ERC20 Contract
  """

  # @bin FileHandler.read(:bin, "contract/erc20/erc20.bin")
  @abi FileHandler.read(:json, "contract/erc20/erc20.abi")
  @func %{
    name: "name",
    symbol: "symbol",
    balance_of: "balanceOf",
    transfer: "transfer"
  }
  @contract_addr System.get_env("erc20_addr")

  def get_param(caller_addr, param) do
    func = Map.get(@func, param)
    {:ok, %{"message" => "success", "transactionHash" => txid}} =
    WeBaseInteractor.handle_tx(
      caller_addr,
      @contract_addr,
      func,
      [],
      @abi
    )
    {:ok, txid}
  end

  def balance_of(caller_addr, addr) do
    {:ok, [balance]} =
    WeBaseInteractor.handle_tx(
      caller_addr,
      @contract_addr,
      @func.balance_of,
      [addr],
      @abi
    )
    {:ok, balance}
  end

  def transfer(caller_addr, to, value) do
    {:ok,
    %{"message" => "success",
    "transactionHash" => tx_id}} =
    WeBaseInteractor.handle_tx(
      caller_addr,
      @contract_addr,
      @func.transfer,
      [to, value],
      @abi
    )
    {:ok, tx_id}
  end
end
