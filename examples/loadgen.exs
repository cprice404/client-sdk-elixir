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

  defmodule Histogram do
    use Agent

    @enforce_keys [:agent]
    defstruct [:agent]

    @opaque t() :: %__MODULE__{
              agent: Agent.agent()
            }

    @spec new() :: t()
    def new() do
      {:ok, histogram} = :hdr_histogram.open(60 * 1000, 3)
      {:ok, agent} = Agent.start_link(fn -> histogram end)

      %__MODULE__{
        agent: agent
      }
    end

    @spec record(histogram :: t(), value :: integer()) :: :void
    def record(histogram, value) do
      Agent.update(histogram.agent, fn h ->
        :hdr_histogram.record(h, value)
        h
      end)
    end

    @spec summary(histogram :: t()) :: String.t()
    def summary(histogram) do
      h = Agent.get(histogram.agent, fn h -> h end)
      """
        count: #{:hdr_histogram.get_total_count(h)}
          min: #{:hdr_histogram.min(h)}
          p50: #{:hdr_histogram.percentile(h, 50.0)}
          p90: #{:hdr_histogram.percentile(h, 90.0)}
          p99: #{:hdr_histogram.percentile(h, 99.0)}
        p99.9: #{:hdr_histogram.percentile(h, 99.9)}
          max: #{:hdr_histogram.max(h)}
      """
      #
#    count: ${histogram.totalCount}
#min: ${histogram.minNonZeroValue}
#p50: ${histogram.getValueAtPercentile(50)}
#  p90: ${histogram.getValueAtPercentile(90)}
# p99: ${histogram.getValueAtPercentile(99)}
# p99.9: ${histogram.getValueAtPercentile(99.9)}
# max: ${histogram.maxValue}


      #
#      io:format("Min ~p~n", [hdr_histogram:min(R)]),
#      io:format("Mean ~.3f~n", [hdr_histogram:mean(R)]),
#      io:format("Median ~.3f~n", [hdr_histogram:median(R)]),
#      io:format("Max ~p~n", [hdr_histogram:max(R)]),
#      io:format("Stddev ~.3f~n", [hdr_histogram:stddev(R)]),
#      io:format("99ile ~.3f~n", [hdr_histogram:percentile(R,99.0)]),
#      io:format("99.9999ile ~.3f~n", [hdr_histogram:percentile(R,99.9999)]),
#      io:format("Memory Size ~p~n", [hdr_histogram:get_memory_size(R)]),
#      io:format("Total Count ~p~n", [hdr_histogram:get_total_count(R)]),
    end

    @spec stop(histogram :: t()) :: :void
    def stop(histogram) do
      Agent.stop(histogram.agent)
    end
  end

  defmodule Counter do
    @enforce_keys [:atomic]
    defstruct [:atomic]

    @opaque t() :: %__MODULE__{
              atomic: :atomics.atomics_ref()
            }

    @spec new() :: t()
    def new() do
      %__MODULE__{
        atomic: :atomics.new(1, [])
      }
    end

    @spec increment(counter :: t()) :: integer()
    def increment(counter) do
      :atomics.add_get(counter.atomic, 1, 1)
    end
  end

  defmodule Context do
    @enforce_keys [
      :start_time,
      :read_latencies,
      :write_latencies,
      :global_request_count,
      :global_success_count,
      :global_unavailable_count,
      :global_deadline_exceeded_count,
      :global_resource_exhausted_count,
      :global_rst_stream_count
    ]
    defstruct [
      :start_time,
      :read_latencies,
      :write_latencies,
      :global_request_count,
      :global_success_count,
      :global_unavailable_count,
      :global_deadline_exceeded_count,
      :global_resource_exhausted_count,
      :global_rst_stream_count
    ]

    @type t() :: %__MODULE__{
            start_time: integer(),
            read_latencies: Histogram.t(),
            write_latencies: Histogram.t(),
            global_request_count: Counter.t(),
            global_success_count: Counter.t(),
            global_unavailable_count: Counter.t(),
            global_deadline_exceeded_count: Counter.t(),
            global_resource_exhausted_count: Counter.t(),
            global_rst_stream_count: Counter.t()
          }

    @spec new() :: Context.t()
    def new() do
      %Context{
        start_time: :os.system_time(:milli_seconds),
        read_latencies: Histogram.new(),
        write_latencies: Histogram.new(),
        global_request_count: Counter.new(),
        global_success_count: Counter.new(),
        global_unavailable_count: Counter.new(),
        global_deadline_exceeded_count: Counter.new(),
        global_resource_exhausted_count: Counter.new(),
        global_rst_stream_count: Counter.new()
      }
    end

    @spec stop(context :: t()) :: :void
    def stop(context) do
      Histogram.stop(context.read_latencies)
      Histogram.stop(context.write_latencies)
    end
  end

  @cache_name "elixir-loadgen"

  @spec main(options :: Options.t()) :: :void
  def main(options) do
    cache_client =
      CacheClient.create!(
        Configurations.Laptop.latest(),
        CredentialProvider.from_env_var!("MOMENTO_AUTH_TOKEN"),
        60
      )

    CacheClient.create_cache(cache_client, @cache_name)

    Logger.info("Limiting to #{options.max_requests_per_second} tps")
    Logger.info("Running #{options.number_of_concurrent_requests} concurrent requests")
    Logger.info("Running for #{options.total_seconds_to_run} seconds")

    context = Context.new()

    Histogram.record(context.read_latencies, 42)
    Histogram.record(context.read_latencies, 500)
    Histogram.record(context.read_latencies, 11)
#    Histogram.record(context.read_latencies, 90210)
    Histogram.record(context.read_latencies, 66)

    Logger.info("Read latencies summary:\n\n#{Histogram.summary(context.read_latencies)}\n\n")

    Context.stop(context)
  end
end

# alias Momento.Examples.LoadGen

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
