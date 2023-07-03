require Logger

defmodule StandalonePingRepro do
  def main do
    Logger.info("Hello world")
    tls_options = :tls_certificate_check.options("cache.cell-alpha-dev.preprod.a.momentohq.com")
    {:ok, channel} = GRPC.Stub.connect(
      "cache.cell-alpha-dev.preprod.a.momentohq.com:443",
      cred: GRPC.Credential.new(ssl: tls_options)
    )
    request = %Momento.Protos.CacheClient.PingRequest{}
    for n <- 1..1_000 do
      start_time = :os.system_time(:milli_seconds)
#      response = Hello.Hello.Stub.hello(channel, request)
      response = Momento.Protos.CacheClient.Ping.Stub.ping(channel, request)
      Logger.info("RESPONSE: #{inspect(response)}")
      duration = :os.system_time(:milli_seconds) - start_time
      Logger.info("Finished request; duration: #{duration}")
    end
  end
end
