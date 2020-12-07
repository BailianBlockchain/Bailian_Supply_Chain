defmodule SupplyChain.CredentialVerifier do
  use Directive, :schema

  schema "credential_verifier" do
    field :pubkey
    field :file
  end

  def changeset(credential_verifier, params \\ :invalid) do
    credential_verifier
    |> cast(params, [:pubkey, :file])
    |> validate_required([:pubkey, :file])
  end
end
