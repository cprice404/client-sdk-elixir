require Logger

defmodule Momento.Examples.LoadGen do
  alias Momento.CacheClient
  alias Momento.Configurations
  alias Momento.Auth.CredentialProvider

  defmodule Options do
    @enforce_keys [
      :show_stats_interval_seconds,
      :request_timeout_ms,
      :cache_item_payload_bytes,
      :max_requests_per_second,
      :number_of_concurrent_requests,
      :total_seconds_to_run
    ]
    defstruct [
      :show_stats_interval_seconds,
      :request_timeout_ms,
      :cache_item_payload_bytes,
      :max_requests_per_second,
      :number_of_concurrent_requests,
      :total_seconds_to_run
    ]

    @type t() :: %__MODULE__{
      show_stats_interval_seconds: number(),
      request_timeout_ms: number(),
      cache_item_payload_bytes: number(),
      max_requests_per_second: number(),
      number_of_concurrent_requests: number(),
      total_seconds_to_run: number()
   }
  end

  @cache_name "elixir-loadgen"

  @spec main(options :: Momento.Examples.LoadGen.Options.t()) :: :void
  def main(options) do
    cache_client = CacheClient.create!(
      Configurations.Laptop.latest(),
      CredentialProvider.from_env_var!("MOMENTO_AUTH_TOKEN"),
      60
    )

    CacheClient.create_cache(cache_client, @cache_name)

    Logger.info("Limiting to #{options.max_requests_per_second} tps");
    Logger.info("Running #{options.number_of_concurrent_requests} concurrent requests");
    Logger.info("Running for #{options.total_seconds_to_run} seconds");

    foo = :atomics.new(1, [])
    x = :atomics.get(foo, 1)
    Logger.info("The first atomic is #{x}")
    y = :atomics.add_get(foo, 1, 10)
    Logger.info("The incremented atomic is #{y}")
  end
end

#alias Momento.Examples.LoadGen

defmodule Main do
  def main() do
    options = %Momento.Examples.LoadGen.Options{
      show_stats_interval_seconds: 5,
      request_timeout_ms: 15 * 1000,
      cache_item_payload_bytes: 100,
      max_requests_per_second: 100,
      number_of_concurrent_requests: 10,
      total_seconds_to_run: 60
    }

    Momento.Examples.LoadGen.main(options)
  end
end

Main.main()
