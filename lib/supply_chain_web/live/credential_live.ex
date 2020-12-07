defmodule SupplyChainWeb.CredentialLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    context: <%= @credential."@context"%>
    <br>
    ----------------
    <br>
    <%= for payload <- @credential.claim do %>
      <%=payload |> elem(0)%>:<%=payload |> elem(1)%>
      <br>
    <%end%>
    ----------------
    <br>
    cptId: <%= @credential.cptId %>
    <br>
    expirationDate:  <%= @credential.expirationDate %>
    <br>
    issuanceDate: <%= @credential.issuanceDate %>
    <br>
    issuer: <%= @credential.issuer %>
    <br>
    ----------------
    <br>
    <%= for proof <- @credential.proof do %>
      <%=proof |> elem(0)%>:<%=proof |> elem(1)%>
      <br>
    <%end%>
    """
  end

  def read_test_file() do
    File.read!("credential_exp")
    |> Poison.decode!()
    |> StructTranslater.to_atom_struct()
  end

  def mount(_params, _session, socket) do
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

  # defp put_date(socket) do
  #   assign(socket, date: NaiveDateTime.utc_now())
  # end
end
