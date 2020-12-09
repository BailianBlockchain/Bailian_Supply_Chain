defmodule SupplyChainWeb.SignLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias SupplyChainWeb.SignView
  alias SupplyChain.{Chain, Erc20Handler, Did, Participater}
  alias Decimal, as: D

  @money_center System.get_env("money_center")
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

  def handle_event("pay", %{"payloads" => %{"chain" => chain_title, "money" => money}}, socket) do
    chain =
      chain_title
      |> Chain.get_by_title()
      |> Chain.preload()
    {:ok, p_infos} = pay_to_participaters(chain.item, money)
    {:noreply,
    socket
    |> assign(:p_infos, p_infos)}
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

  def pay_to_participaters(items, money) do
    payloads = Enum.map(items, fn item ->
        pay_to_participater(item, money)
    end)
    {:ok, payloads}
  end

  def pay_to_participater(%{portion: portion, participater: %{did: did} = participater}, money) do
    money_d = D.new(money)
    portion_d = D.new("#{portion}")
    money_actually_get = D.mult(money_d, portion_d)
    money_pure =
      money_actually_get
      |> D.mult(D.new("100"))
      |> D.to_integer()


    {:ok, tx_id} =
    Erc20Handler.transfer(@money_center, Did.did_to_addr(did), money_pure)

    {:ok, participater}
    Participater.update(
      participater, %{balance: participater.balance + money_pure}

    )
    balance_actual =
      participater.balance
      |> D.div(D.new("100"))
      |> D.to_float()
    {participater.name, D.to_float(money_actually_get), tx_id, balance_actual}
  end
end
