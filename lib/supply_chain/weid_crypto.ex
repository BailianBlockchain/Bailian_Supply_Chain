defmodule SupplyChain.WeidCrypto do
  @moduledoc """
    doc for WeidCrypto
    using lib:
    {:binary, "~> 0.0.5"}
  """

  @doc """
    ref impl on:
    https://github.com/WeBankFinTech/WeIdentity-Go-Lite-Client/blob/master/client/client.go
  """
  def gen_keys() do
    %{pub: pub, priv: priv} = Crypto.generate_key_secp256k1()
    %{pub: Binary.drop(pub, 1), priv: priv}
  end
end
