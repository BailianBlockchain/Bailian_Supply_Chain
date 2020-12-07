defmodule SupplyChain.Repo do
  use Ecto.Repo,
    otp_app: :supply_chain,
    adapter: Ecto.Adapters.Postgres
end
