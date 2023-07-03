require Logger

defmodule StandalonePingRepro do
  def ssl_verify_fun(otpCert, event, initialUserState) do
    {:fail, "GO AWAY"}
  end


  def main do
    Logger.info("Hello world")
#    tls_options = :tls_certificate_check.options("cache.cell-alpha-dev.preprod.a.momentohq.com")
#    tls_options = [
#      verify: :verify_peer, depth: 100, cacerts: :certifi.cacerts(),
#      verify_fun: fn cert, event, userstate -> ssl_verify_fun(cert, event, userstate) end
#    ]
    tls_options = [
      verify: :verify_none
    ]
    # verify_fun: {&:ssl_verify_hostname.verify_fun/3,
    #                   [check_hostname: 'cache.cell-alpha-dev.preprod.a.momentohq.com']},
    # partial_chain: &:tls_certificate_check_shared_state.find_trusted_authority/1,
    # customize_hostname_check: [match_fun: #Function<6.29392970/2 in
    #                               :public_key.pkix_verify_hostname_match_fun/1>],
    # server_name_indication: 'cache.cell-alpha-dev.preprod.a.momentohq.com']
    Logger.info("TLS OPTIONS: #{inspect(tls_options)}")
    {:ok, channel} = GRPC.Stub.connect(
      "cache.cell-alpha-dev.preprod.a.momentohq.com:443",
      cred: GRPC.Credential.new([])
#      cred: GRPC.Credential.new(ssl: tls_options)
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
