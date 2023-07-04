require Logger

defmodule ElixirGunClient do

  def main do
    Logger.info("Hello world")
#    open_opts = %{protocols: [:http2]}
#    open_opts = %{}
    open_opts = %{transport: :tls}
    {:ok, conn_pid} = :gun.open(String.to_charlist("localhost"), 8000, open_opts)

#    {:ok, :http2} = :gun.await_up(conn_pid)
    {:ok, :http} = :gun.await_up(conn_pid)

    for n <- 1..1_000 do
      start_time = :os.system_time(:milli_seconds)
      stream_ref = :gun.get(conn_pid, "/")
      Logger.info("Stream ref: #{inspect(stream_ref)}")
      headers = :gun.await(conn_pid, stream_ref)
      Logger.info("Headers: #{inspect(headers)}")
      body = :gun.await(conn_pid, stream_ref)
      Logger.info("Body: #{inspect(body)}")
      duration = :os.system_time(:milli_seconds) - start_time
      Logger.info("Finished request; duration: #{duration}")
    end
  end
end
