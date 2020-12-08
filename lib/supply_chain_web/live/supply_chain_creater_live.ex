defmodule SupplyChainWeb.SupplyChainCreaterLive do
  use Phoenix.LiveView

  @deployer_addr System.get_env("deployer_addr")

  alias SupplyChain.{Item, Chain, Participater, EvidenceHandler, Did, Contract, Evidence}
  alias SupplyChainWeb.SupplyChainView
  alias SupplyChainWeb.Router.Helpers, as: Routes

  def render(assigns), do: SupplyChainView.render("create.html", assigns)

  def mount(_params, _session, socket) do
    participaters =
      Participater.get_all()
      |> Enum.map(fn ele -> ele.name end)

    {:ok,
     socket
     |> assign(forms: :payloads)
     |> assign(items: 0)
     |> assign(participaters: participaters)
     |> assign(title: "default title")
     |> assign(abstract: "default abstract")}
  end

  def get_item(payloads, prefix_str) do
    Enum.filter(payloads, fn {key, value} ->
      key_str = Atom.to_string(key)

      key_str
      |> String.split("_")
      |> Enum.fetch!(0)
      |> Kernel.==(prefix_str)
    end)
  end

  def handle_key(item) do
    item
    |> Enum.map(fn {key, value} ->
      key_handled =
        key
        |> Atom.to_string()
        |> String.split("_", parts: 2)
        |> Enum.fetch!(1)
        |> String.to_atom()

      {key_handled, value}
    end)
    |> Enum.into(%{})
  end

  def insert_item(item, item_num, chain, nil) do
    do_insert_item(item, item_num, chain, nil)
  end

  def insert_item(item, item_num, chain, last_one) do
    do_insert_item(item, item_num, chain, last_one.id)
  end

  def do_insert_item(item, item_num, chain, last_one_id) do
    participater = Participater.get_by_name(item.participater)

    payload = %{
      level_on_chain: item_num,
      portion: item.portion,
      role: item.role,
      chain_id: chain.id,
      participater_id: participater.id,
      last_item_id: last_one_id
    }

    {:ok, item} = Item.create(payload)
    item
  end

  def gen_portion_payload(chain) do
    chain
    |> Map.get(:item)
    |> Enum.map(fn item ->
      participater_addr
       = item.participater.did
        |> SupplyChain.Did.did_to_addr()
        |> String.to_atom()
      {participater_addr, item.portion}
    end)
    |> Enum.into(%{})
  end

  # +--------------+
  # | handle event |
  # +--------------+
  def handle_event("new_item", payloads, socket) do
    {:noreply,
     socket
     |> assign(items: socket.assigns.items + 1)}
  end

  def handle_event("save", %{"payloads" => payloads}, socket) do
    payloads_atom = StructTranslater.to_atom_struct(payloads)

    {:ok, chain} =
      Chain.create(%{
        title: payloads_atom.title,
        abstract: payloads_atom.abstract,
        status: "draft"
      })

    0..socket.assigns.items
    |> Enum.map_reduce(nil, fn item_num, last_one ->
      prefix_str = "item" <> inspect(item_num)

      item =
        payloads_atom
        |> get_item(prefix_str)
        |> handle_key()
        |> insert_item(item_num, chain, last_one)

      {:nothing, item}
    end)

    chain_preloaded = Chain.preload(chain)
    participaters = Chain.get_all_participater(chain_preloaded)
    IO.puts inspect participaters
    addr_list =
      participaters
      |> Enum.map(fn p ->
        Did.did_to_addr(p.did)
      end)
    id_list =
      participaters
      |> Enum.map(fn p ->
        p.id
      end)

    portion_payload_str =
      chain_preloaded
      |> gen_portion_payload()
      |> Poison.encode!()
    deployer_addr = @deployer_addr

    {:ok, contract_addr} = EvidenceHandler.deploy(deployer_addr, [deployer_addr] ++ addr_list)

    {:ok, contract} =
      Contract.create(%{
        addr: contract_addr,
        chain_id: chain_preloaded.id,
        type: Atom.to_string(:evidence),
        describe: "step A",
        owner_did: SupplyChain.Did.addr_to_did(deployer_addr)
      })

    {:ok, key, tx_id} =
      EvidenceHandler.new_evidence(
        deployer_addr,
        contract.addr,
        portion_payload_str
        )

    {:ok, evi} =
      Evidence.create(%{
        key: key,
        tx_id: tx_id,
        value: portion_payload_str,
        describe: "root tx",
        owners: id_list,
        contract_id: contract.id
      })
    {
      :noreply,
      socket
      |> put_flash(:info, "created!")
      # |> redirect(external: "https://www.baidu.com")
      |> redirect(
        to: Routes.live_path(socket, SupplyChainWeb.SupplyChainDetailLive, %{chain_id: chain.id})
      )
    }
  end

  def handle_event(_, %{"payloads" => payloads}, socket) do
    payloads_atom = StructTranslater.to_atom_struct(payloads)

    {
      :noreply,
      socket
      |> assign(title: payloads_atom.title)
      |> assign(abstract: payloads_atom.abstract)
    }
  end
end
