defmodule SupplyChain.WeidAdapter do
  @moduledoc """
    Adapter to Weid Restful Service.
    Waiting for recognizeAuthorityIssuer().


  """

  @weid_path "/weid/api/"
  @path %{
    invoke: @weid_path <> "invoke",
    encode: @weid_path <> "encode",
    transact: @weid_path <> "transact"
  }

  @payload_basic %{
    "functionArg" => %{},
    "functionName" => "",
    "transactionArg" => %{},
    "v" => "1.0.0"
  }
  @body_create_weid %{@payload_basic | "functionName" => "createWeId"}
  @body_get_weid_doc %{@payload_basic | "functionName" => "getWeIdDocument"}
  @body_create_weid_second_step %{@payload_basic | "functionName" => "createWeId"}
  @body_register_authority_issuer %{@payload_basic | "functionName" => "registerAuthorityIssuer"}
  @body_query_authority_issuer %{@payload_basic | "functionName" => "queryAuthorityIssuer"}
  @body_verify_credential %{@payload_basic | "functionName" => "verifyCredential"}

  @doc """
    create weid hosting by weid-restful-service
  """

  def create_weid(:test) do
    MockCenter.create_weid_result()
  end

  @spec create_weid(String.t()) :: {:error, any} | {:ok, any}
  def create_weid(node) do
    node
    |> Kernel.<>(@path.invoke)
    |> Http.post(@body_create_weid)
    |> handle_result()
  end

  def get_weid_document(:test, _) do
  end

  def get_weid_document(node, weid) do
    body_get_weid_doc = %{@body_get_weid_doc | "functionArg" => %{"weId" => weid}}

    node
    |> Kernel.<>(@path.invoke)
    |> Http.post(body_get_weid_doc)
    |> handle_result()
  end

  def register_authority_issuer(:test, _, _, _, _) do
  end

  @spec register_authority_issuer(String.t(), String.t(), String.t(), String.t()) ::
          {:error, any} | {:ok, true}
  def register_authority_issuer(node, issuer_weid, org_name, invoker_weid) do
    function_arg = %{"weId" => issuer_weid, "name" => org_name}
    invoker_weid_arg = %{"invokerWeId" => invoker_weid}

    payload =
      @body_register_authority_issuer
      |> Map.put("functionArg", function_arg)
      |> Map.put("transactionArg", invoker_weid_arg)

    node
    |> Kernel.<>(@path.invoke)
    |> Http.post(payload)
    |> handle_result()
  end

  def query_authority_issuer(:test, _) do
  end

  def query_authority_issuer(node, query_weid) do
    payload =
      @body_query_authority_issuer
      |> Map.put("functionArg", %{"weId" => query_weid})

    node
    |> Kernel.<>(@path.invoke)
    |> Http.post(payload)
    |> handle_result()
  end

  def create_credential(:test, _) do
  end

  def create_credential() do
  end

  def verify_credential(:test, _) do
  end

  def verify_credential(node, credential) do
    payload =
      @body_verify_credential
      |> Map.put("functionArg", credential)

    node
    |> Kernel.<>(@path.invoke)
    |> Http.post(payload)
    |> handle_result()
  end

  @doc """
    create_weid_by_pubkey
  """
  def create_weid(node, priv, pubkey) do
    with {:ok, %{"nonce" => nonce, "data" => data}} <- create_weid_first_step(node, pubkey) do
      create_weid_second_step(node, nonce, data, priv)
    else
      error -> error
    end
  end

  defp create_weid_first_step(node, pubkey) do
    nonce = RandGen.gen_num(32)

    body_create_weid =
      @body_create_weid
      |> Map.put("functionArg", %{"publicKey" => inspect(pubkey)})
      |> Map.put("transactionArg", %{"nonce" => inspect(nonce)})

    result =
      node
      |> Kernel.<>(@path.encode)
      |> Http.post(body_create_weid)
      |> handle_result()

    case result do
      {:ok, payload} -> {:ok, Map.put(payload, "nonce", nonce)}
      _ -> result
    end
  end

  defp create_weid_second_step(_node, nonce, data, priv) do
    sig = sign(priv, data)

    transaction_arg =
      %{}
      |> Map.put("nonce", nonce)
      |> Map.put("data", data)
      |> Map.put("signedMessage", sig)

    body_create_weid_second_step = %{
      @body_create_weid_second_step
      | "transactionArg" => transaction_arg
    }

    # result=
    #   node
    #   |> Kernel.<>(@path.transact)
    #   |> Http.post(body_create_weid_second_step)
    #   |> handle_result()
    body_create_weid_second_step
  end

  def sign(_priv, _data) do
  end

  defp handle_result({:error, error_info}), do: {:error, error_info}
  defp handle_result({:ok, %{"errorCode" => 0, "respBody" => payload}}), do: {:ok, payload}
  defp handle_result({:ok, %{"errorMessage" => error_msg}}), do: {:error, error_msg}
end
