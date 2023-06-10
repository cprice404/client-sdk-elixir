defmodule Momento.Internal.ScsControlClient do
  alias Momento.Auth.CredentialProvider
#  @spec init_channel(config :: Momento.Configuration.t(), credential_provider :: Momento.Auth.CredentialProvider.t()) ::
#          {:ok, GRPC.Channel.t()} | {:error, any()}
#  String.t()
#          {:ok, GRPC.Channel.t()} | {:error, String.t()}
#  def init_channel(config, credential_provider) do
  @spec init_channel(credential_provider :: CredentialProvider.t()) ::
#          @spec init_channel(credential_provider :: %Momento.Auth.CredentialProvider{:control_endpoint => binary(), _ => _}) ::

#          @spec init_channel(control_endpoint :: String.t()) ::
  String.t()
#        GRPC.Channel.t()
  def init_channel(credential_provider) do
    %CredentialProvider{control_endpoint: control_endpoint} = credential_provider
    control_endpoint
#    Map.fetch!(credential_provider, :control_endpoint)
#    credential_provider.control_endpoint
#    "foo"
#  {:ok, channel} = GRPC.Stub.connect(control_endpoint <> ":443",
##    {:ok, channel} = GRPC.Stub.connect(host <> ":443",
#      cred: GRPC.Credential.new([])
#    )
#    channel
  end

  #
#  @spec create_grpc_channel(host :: String.t()) :: GRPC.Channel.t()
#  def create_grpc_channel(host) do
#    {:ok, channel} = GRPC.Stub.connect(host <> ":443",
#      cred: GRPC.Credential.new([])
#    )
#    channel
#  end
end
