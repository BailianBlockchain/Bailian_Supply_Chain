defmodule SupplyChainWeb.SupplyChainLoginedLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias SupplyChain.{Chain, Item, User, Participater}
  alias SupplyChainWeb.SupplyChainView
  alias SupplyChainWeb.Router.Helpers, as: Routes

  def render(assigns), do: SupplyChainView.render("index_logined.html", assigns)

  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    user =
      current_user_id
      |> User.get_by_userid()
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

  def put_payload(socket, chains, participater) do
    assign(socket, chains: chains, participater: participater)
  end
end
