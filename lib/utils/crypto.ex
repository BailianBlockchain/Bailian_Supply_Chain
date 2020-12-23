defmodule Crypto do
  @moduledoc """
  using lib:
   {:libsecp256k1, [github: "mbrix/libsecp256k1", manager: :rebar]}
  """
  def sha256(data), do: :crypto.hash(:sha256, data)
  def ripemd160(data), do: :crypto.hash(:ripemd160, data)
  def double_sha256(data), do: data |> sha256 |> sha256

  def secp256k1_sign(data, private_key) do
    {:ok, signature} = :crypto.sign(:ecdsa, :sha256, data, [priv, :secp256k1])
    signature
  end

  def generate_key_secp256k1() do
    {pubkey, privkey} = :crypto.generate_key(:ecdh, :secp256k1)

    if byte_size(privkey) != 32 do
      generate_key_secp256k1()
    else
      %{pub: pubkey, priv: privkey}
    end
  end

  def generate_key_secp256k1(private_key) do
    :crypto.generate_key(:ecdh, :secp256k1, private_key)
  end
end
