defmodule Momento.Internal.ScsDataClient do
  @spec init_channel(config :: Momento.Configuration.t(), credential_provider :: Momento.Auth.CredentialProvider.t()) ::
  String.t()
#          {:ok, GRPC.Channel.t()} | {:error, any()}
  def init_channel(config, credential_provider) do
    "foo"
#    {:error, "foo"}
#    GRPC.Stub.connect(credential_provider.cache_endpoint <> ":443", cred: GRPC.Credential.new([]))
  end

  @spec set(cache_client :: Momento.CacheClient.t(), cache_name :: String.t(), key :: binary(), value :: binary(), ttl_seconds :: float()) ::
          Momento.Responses.Set.t()
  def set(cache_client, cache_name, key, value, ttl_seconds) do
    :success
#    ttl_milliseconds = ttl_seconds |> Kernel.*(1000) |> round()
#    metadata = %{cache: cache_name, Authorization: cache_client.credential_provider.auth_token}
#
#    setRequest = %CacheClient.SetRequest{
#      cache_key: key,
#      cache_body: value,
#      ttl_milliseconds: ttl_milliseconds
#    }
#
#    case CacheClient.Scs.Stub.set(cache_client.cache_channel, setRequest, metadata: metadata) do
#      {:ok, _} -> :success
#      {:error, error_response} -> {:error, Momento.Error.convert(error_response)}
#    end
  end

  @spec get(cache_client :: Momento.CacheClient.t(), cache_name :: String.t(), key :: binary()) ::
          Momento.Responses.Get.t()
  def get(cache_client, cache_name, key) do
    :miss

    #    metadata = %{cache: cache_name, Authorization: cache_client.credential_provider.auth_token}
    #
    #    getRequest = %CacheClient.GetRequest{cache_key: key}
    #
    #    case CacheClient.Scs.Stub.get(cache_client.cache_channel, getRequest, metadata: metadata) do
    #      {:ok, %CacheClient.GetResponse{result: :Hit, cache_body: cache_body}} -> {:hit, cache_body}
    #      {:ok, %CacheClient.GetResponse{result: :Miss}} -> :miss
    #      {:error, error_response} -> {:error, Momento.Error.convert(error_response)}
    #    end
  end
end
