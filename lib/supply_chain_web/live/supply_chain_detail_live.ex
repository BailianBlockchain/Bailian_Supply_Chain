defmodule SupplyChainWeb.SupplyChainDetailLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias SupplyChain.{Chain, Item}
  alias SupplyChainWeb.SupplyChainView
  alias SupplyChainWeb.Router.Helpers, as: Routes

  def render(assigns), do: SupplyChainView.render("index.html", assigns)

  def mount(params, _session, socket) do
    {:ok, put_items(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_items(socket)}
  end

  def handle_event("nav", _path, socket) do
    {:noreply, socket}
  end

  defp put_items(socket) do
    assign(socket, items: [:item1, :item2])
  end

  def handle_params(%{"chain_id" => chain_id}, _url, socket) do
    chain =
      chain_id
      |> Chain.get_by_id()
      |> Chain.preload()

    {:noreply,
     socket
     |> assign(chain: chain)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, socket}
  end
end
