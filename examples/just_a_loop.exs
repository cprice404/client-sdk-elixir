require Logger

defmodule Main do
  alias Momento.CacheClient
  alias Momento.Configurations
  alias Momento.Auth.CredentialProvider

  def main() do
    client = CacheClient.create!(
      Configurations.Laptop.latest(),
      CredentialProvider.from_env_var!("MOMENTO_AUTH_TOKEN"),
      60
    )

    cache_value = String.duplicate("x", 100)

    for n <- 1..1_00 do
      write_start_time = :os.system_time(:milli_seconds)
      Logger.info("Starting write at #{write_start_time}")

      CacheClient.set(client, "cache", "key#{n}", cache_value)

      write_duration = :os.system_time(:milli_seconds) - write_start_time
      Logger.info("Finished write; duration: #{write_duration}")

      read_start_time = :os.system_time(:milli_seconds)
      Logger.info("Starting read at #{read_start_time}")

      CacheClient.get(client, "cache", "key#{n}")

      read_duration = :os.system_time(:milli_seconds) - read_start_time
      Logger.info("Finished read; duration: #{read_duration}")
    end
  end
end

:fprof.start()
:fprof.trace([:start, procs: :all])
#:eprof.start_profiling([self()])
Main.main()
#:eprof.stop_profiling()
#:eprof.analyze()
:fprof.trace(:stop)
:fprof.profile()
:fprof.analyse(totals: true, dest: 'prof.analysis')
