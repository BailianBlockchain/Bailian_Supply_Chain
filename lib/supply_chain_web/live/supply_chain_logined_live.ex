defmodule SupplyChainWeb.SupplyChainLoginedLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias SupplyChain.{Evidence, Did, Chain, Item, User, Participater, EvidenceHandler}
  alias SupplyChainWeb.SupplyChainView
  alias SupplyChainWeb.Router.Helpers, as: Routes

  @deployer_addr System.get_env("deployer_addr")

  def render(assigns), do: SupplyChainView.render("index_logined.html", assigns)

  def handle_event("check_status", %{"ref" => chain_id}, socket) do
    %{contract: %{evidence: evi}} = chain =
      chain_id
      |> Chain.get_by_id()
      |> Chain.preload()
      {:ok, [ _evi_payload, owner_list, signer_addr_list]} =
      EvidenceHandler.get_evidence(
        @deployer_addr,
        evi
      )

      signer_list =
        signer_addr_list
      |> Enum.reject(&(&1==@deployer_addr))
      |> Enum.map(fn signer_addr ->
        signer_addr
        |> Did.addr_to_did()
        |> Participater.get_by_did()
      end)

      signer_id_list = Enum.map(signer_list,&(&1.id))
      {:ok, evi} = Evidence.update(evi, %{signers: signer_id_list})
      signer_name_list = Enum.map(signer_list,&(&1.name))

      {:ok, chain_new} = change_status(evi, chain)
      signer_portion = "#{Enum.count(evi.signers)} / #{Enum.count(evi.owners)}"

      chains_updated =
        socket.assigns.chains
        |> Enum.map(fn chain->
          update_chain(chain, chain_new)
        end)

    {
      :noreply,
      socket
      |> assign(signers: signer_name_list)
      |> assign(signer_portion: signer_portion)
      |> assign(chains: chains_updated)
    }
  end

  def update_chain(%{id: id}=chain, %{id: new_id} = new_chain)
    when id==new_id
    do
      new_chain
  end

  def update_chain(chain, _new_chain) do
    chain
  end

  def change_status(%{signers: signers, owners: owners}, chain) do
    if Enum.count(signers) == Enum.count(owners) do
      Chain.update(chain, %{status: "confirmed"})
    else
      {:ok, chain}
    end
  end

  def mount(params, %{"current_user_id" => current_user_id}, socket) do
    IO.puts "id"
    IO.puts inspect params
    user =
      current_user_id
      |> User.get_by_user_id()
      |> User.preload()

    chains =
      user.participater.id
      |> Item.get_by_participater_id()
      |> Enum.map(&(&1.chain_id))
      |> Enum.map(fn id ->
        id
        |> Chain.get_by_id()
        |> Chain.preload()
      end)
    {:ok, put_payload(socket, chains, user.participater)}
  end

  def mount(params, others, socket) do
    IO.puts "socket here"
    IO.puts inspect params
    IO.puts inspect others
    IO.puts inspect socket.assigns
    {:ok, socket}
  end

  def put_payload(socket, chains, participater) do
    IO.puts "participater here"
    IO.puts inspect participater
    socket
    |> assign(chains: chains)
    |> assign(participater: participater)
    |> assign(signers: nil)
  end
end
