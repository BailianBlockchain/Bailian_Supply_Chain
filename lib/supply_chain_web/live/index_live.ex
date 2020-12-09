defmodule SupplyChainWeb.IndexLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <center>
        <h2>验证</h2>
      </center>
      <label>File</label>
    </div>
    """
  end

  def read_test_file() do
    File.read!("credential_exp")
    |> Poison.decode!()
    |> StructTranslater.to_atom_struct()
  end

  def mount(_params, session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)
    {:ok, init(socket)}
  end

  def init(socket) do
    socket
    |> assign(:credential, read_test_file())
  end

  def handle_info(:tick, socket) do
    {:noreply, socket}
  end

  def handle_event("nav", _path, socket) do
    {:noreply, socket}
  end

end
