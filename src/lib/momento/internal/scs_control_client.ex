defmodule Momento.Internal.ScsControlClient do
  @spec init_channel(config :: Momento.Configuration.t(), credential_provider :: Momento.Auth.CredentialProvider.t()) ::
          {:ok, GRPC.Channel.t()} | {:error, any()}
#  String.t()
#          {:ok, GRPC.Channel.t()} | {:error, String.t()}
  def init_channel(config, credential_provider) do
#    "foo"
    GRPC.Stub.connect(credential_provider.control_endpoint <> ":443",
      cred: GRPC.Credential.new([])
    )
  end
end
