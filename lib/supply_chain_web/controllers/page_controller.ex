defmodule SupplyChainWeb.PageController do
  use SupplyChainWeb, :controller
  alias SupplyChain.CredentialVerifier, as: CredentialVerifier
  alias SupplyChain.WeidAdapter, as: WeidAdapter

  @payload %{
    name: "Super Supply Chain·基于区块链的供应链管理结算平台",
    slogan: "极速结算",
    credetialverifier: %CredentialVerifier{},
    changeset: nil,
    verify_result: nil
  }

  @doc """
    post action
  """

  def index(
        conn,
        %{
          "btn_clicked" => "verify",
          "credential_verifier" => %{
            # "pubkey" => pubkey,
            "file" => %Plug.Upload{
              filename: _f_name,
              path: path
            }
          }
        }
      ) do
    credential =
      path
      |> File.read!()
      |> Poison.decode!()

    {_result, msg} = WeidAdapter.verify_credential(System.get_env("weid_node"), credential)

    conn
    |> put_flash(:info, handle_msg(msg))
    |> render("index.html", payload: create_payload())
  end

  def index(conn, %{"btn_clicked" => "read"}) do
    IO.puts(inspect("read"))

    conn
    |> redirect(to: Routes.credential_path(conn, :index, %{read: "read"}))
  end

  @doc """
    get action.
  """
  def index(conn, _params) do
    render(conn, "index.html", payload: create_payload())
  end

  def handle_msg(true), do: "证书合法！"

  def handle_msg(other), do: "验证失败！原因：#{other}"

  def create_payload() do
    changeset = Ecto.Changeset.change(%CredentialVerifier{})
    %{@payload | changeset: changeset}
  end
end
