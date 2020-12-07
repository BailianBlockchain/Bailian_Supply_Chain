defmodule SupplyChain.HelloWorldHandler do
  @moduledoc """
    handle with HelloWorld Contract
  """

  @hello_bin FileHandler.read(:bin, "contract/hello_world/hello_world.bin")
  @hello_abi FileHandler.read(:json, "contract/hello_world/hello_world.abi")

  def get_evidence(addr) do
  end

  def new_evidence(evidence) do
  end

  def deploy(signer_addr) do
    WeBaseInteractor.deploy(
      signer_addr,
      @hello_bin,
      @hello_abi,
      []
    )
  end

  def add_signatures(addr) do
  end

  def get_signers() do
  end
end
