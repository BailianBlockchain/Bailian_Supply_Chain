defmodule SupplyChainWeb.PayLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias SupplyChainWeb.PayView
  alias SupplyChain.{Chain, Erc20Handler, Did, Participater}
  alias Decimal, as: D

  @money_center System.get_env("money_center")
  def render(assigns), do: PayView.render("pay.html", assigns)
  def mount(_params, _session, socket) do
    chains =
      Chain.get_all()
      |> Enum.reject(&(&1.status == "draft"))
      |> Enum.map(&(&1.title))
    {:ok,
    socket
    |> assign(:money, 0)
    |> assign(:chains, chains)
    |> assign(forms: :payloads)
    |> assign(:p_infos, nil)
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

  def handle_event(_event, _payloads, socket) do
    {:noreply, socket}
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
