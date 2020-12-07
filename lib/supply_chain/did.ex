defmodule SupplyChain.Did do
  def did_to_addr(did) do
    did
    |> String.split(":")
    |> Enum.fetch!(2)
  end

  def addr_to_did(addr) do
    "did:" <> addr
  end
end
