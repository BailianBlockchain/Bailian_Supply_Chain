defmodule WeBaseInteractor do
  @handle_tx_body_struct %{
    user: nil,
    contractAddress: nil,
    funcName: nil,
    contractAbi: nil,
    funcParam: nil,
    groupId: nil
  }

  @deploy_body_struct %{
    groupId: nil,
    user: nil,
    bytecodeBin: nil,
    abiInfo: nil,
    funcParam: nil
  }

  @node System.get_env("webase_node")
  @handle_tx_url @node <> "/WeBASE-Front/trans/handle"
  @deploy_url @node <> "/WeBASE-Front/contract/deploy"
  @create_account_url @node <> "/WeBASE-Front/privateKey/import"

  def handle_tx(user_addr, contract_addr, func_name, func_param, contract_abi) do
    handle_tx(user_addr, contract_addr, func_name, func_param, contract_abi, 1)
  end

  def create_account(priv_key, user_name) do
    url =
      @create_account_url
      |> Kernel.<>("?privateKey=#{priv_key}")
      |> Kernel.<>("&userName=#{user_name}")
      |> URI.encode()
    {:ok, %{
      "address" => addr
    }} = Http.get(url)
    {:ok, addr}
  end

  def handle_tx(user_addr, contract_addr, func_name, func_param, contract_abi, group_id) do
    body =
      @handle_tx_body_struct
      |> Map.put(:user, user_addr)
      |> Map.put(:contractAddress, contract_addr)
      |> Map.put(:funcName, func_name)
      |> Map.put(:funcParam, func_param)
      |> Map.put(:contractAbi, contract_abi)
      |> Map.put(:groupId, group_id)

    Http.post(@handle_tx_url, body)
  end

  def deploy(sign_user_id, contract_bin, abi, func_param) do
    deploy(sign_user_id, contract_bin, abi, func_param, 1)
  end

  def deploy(sign_user_id, contract_bin, abi, func_param, group_id) do
    body =
      @deploy_body_struct
      |> Map.put(:user, sign_user_id)
      |> Map.put(:funcParam, func_param)
      |> Map.put(:bytecodeBin, contract_bin)
      |> Map.put(:abiInfo, abi)
      |> Map.put(:groupId, group_id)

    Http.post(@deploy_url, body)
  end
end
