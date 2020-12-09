defmodule SupplyChainWeb.SignLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias SupplyChainWeb.SignView
  alias SupplyChain.{Chain, EvidenceHandler, Did, Participater}

  def render(assigns), do: SignView.render("sign.html", assigns)
  def mount(_params, _session, socket) do
    chains =
      Chain.get_all()
      |> Enum.map(&(&1.title))
    participaters =
      Chain.get_all()
      |> Enum.fetch!(0)
      |> Chain.preload()
      |> Map.get(:item)
      |> Enum.map(&(&1.participater.name))
    {:ok,
    socket
    |> assign(:participaters, participaters)
    |> assign(:chains, chains)
    |> assign(forms: :payloads)
  }
  end

  def handle_event("sign", %{"payloads" => %{"chain" => chain_title, "participater" => p_name}}, socket) do
    chain =
      chain_title
      |> Chain.get_by_title()
      |> Chain.preload()

    p_addr =
      p_name
      |> Participater.get_by_name()
      |> Map.get(:did)
      |> Did.did_to_addr()


    {:ok, %{"transactionHash" => tx_hash}} = EvidenceHandler.add_signatures(p_addr, chain.contract.evidence)
    {
      :noreply,
      socket
      |> put_flash(:info, "Sign Signature SucceSS!")
      |> put_flash(:info_2, "Tx_hash:#{tx_hash}")
    }
  end

  def handle_event(_event, %{"payloads"=> %{"chain" => chain_title}}, socket) do
    chain =
    chain_title
    |> Chain.get_by_title()
    |> Chain.preload()

    participaters =
      chain
      |> Map.get(:item)
      |> Enum.map(&(&1.participater.name))
    {
      :noreply,
      socket
      |> assign(:participaters, participaters)
    }
  end

end
