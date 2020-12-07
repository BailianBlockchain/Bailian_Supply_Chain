defmodule Crypto do
  @moduledoc """
  using lib:
   {:libsecp256k1, [github: "mbrix/libsecp256k1", manager: :rebar]}
  """
  def sha256(data), do: :crypto.hash(:sha256, data)
  def ripemd160(data), do: :crypto.hash(:ripemd160, data)
  def double_sha256(data), do: data |> sha256 |> sha256

  @doc """
  The low S value was enforced since
  [BIP-62](https://github.com/bitcoin/bips/blob/master/bip-0062.mediawiki#low-s-values-in-signatures),
  which means that the `S` value of a ECDSA secp256k1 signature must within certain
  boundary.

  However the signature created by Erlang's `crypto` module, which relies on the
  OpenSSL library are not guaranteed to be consistent with this constraint. Thus
  use Bitcoin core's ECDSA secp256k1 implementation to sign transactions.

  [mbrix/libsecp256k1](https://github.com/mbrix/libsecp256k1) used here provides
  Erlang NIF bindings for Bitcon core's ECDSA secp256k1 library. All available
  methods can be found at `c_src/libsecp256k1_nif.c` file.
  """
  def secp256k1_sign(data, private_key) do
    {:ok, signature} = :libsecp256k1.ecdsa_sign(data, private_key, :default, <<>>)
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
