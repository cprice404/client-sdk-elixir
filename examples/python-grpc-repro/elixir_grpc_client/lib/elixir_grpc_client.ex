require Logger

defmodule ElixirGrpcClient do
  alias Hello.HelloInput

  def main do
    Logger.info("Hello world")
    {:ok, channel} = GRPC.Stub.connect("localhost:9000")
    request = %Hello.HelloInput{}
    for n <- 1..1_000 do
      start_time = :os.system_time(:milli_seconds)
      response = Hello.Hello.Stub.hello(channel, request)
#      Logger.info("RESPONSE: #{inspect(response)}")
      duration = :os.system_time(:milli_seconds) - start_time
      Logger.info("Finished request; duration: #{duration}")
    end
  end
end
