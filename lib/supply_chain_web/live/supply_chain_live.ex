defmodule SupplyChainWeb.SupplyChainLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias SupplyChain.{Chain, Item, User}
  alias SupplyChainWeb.SupplyChainView
  alias SupplyChainWeb.Router.Helpers, as: Routes

  def render(assigns), do: SupplyChainView.render("index.html", assigns)

  def mount(params, _session, socket) do
    {:ok, put_payload(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_payload(socket)}
  end

  defp put_payload(socket) do
    chain_num =
      Chain.get_all()
      |> Enum.count()
    user_num =
      User.get_all()
      |> Enum.count()

    socket
    |> assign(chain_num: chain_num)
    |> assign(user_num: user_num)
  end


end
