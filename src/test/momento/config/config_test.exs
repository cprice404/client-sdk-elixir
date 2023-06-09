defmodule Momento.Config.Configuration do
  import Momento.Config.Transport

  use ExUnit.Case
  doctest Momento.Config.Configuration

  # describe('configuration.ts', () => {
  #  const testLoggerFactory = new DefaultMomentoLoggerFactory();
  #  const testRetryStrategy = new FixedCountRetryStrategy({
  #    loggerFactory: testLoggerFactory,
  #    maxAttempts: 1,
  #  });
  #  const testGrpcConfiguration = new StaticGrpcConfiguration({
  #    deadlineMillis: 90210,
  #    maxSessionMemoryMb: 90211,
  #  });
  #  const testMaxIdleMillis = 90212;
  #  const testTransportStrategy = new StaticTransportStrategy({
  #    grpcConfiguration: testGrpcConfiguration,
  #    maxIdleMillis: testMaxIdleMillis,
  #  });
  #  const testMiddlewares: Middleware[] = [];
  #  const testConfiguration = new CacheConfiguration({
  #    loggerFactory: testLoggerFactory,
  #    retryStrategy: testRetryStrategy,
  #    transportStrategy: testTransportStrategy,
  #    middlewares: testMiddlewares,
  #  });

  @test_grpc_configuration %StaticGrpcStrategy{
    deadline_millis: 90210
  }

  @test_transport_strategy %StaticTransportStrategy{
    grpc_configuration: @test_grpc_configuration
  }

  @test_configuration %Momento.Config.Configuration{
    transport_strategy: @test_transport_strategy
  }

  describe "Constructing Configuration" do
    test "overriding transport strategy" do
      new_grpc_configuration = %StaticGrpcConfiguration{
        deadline_millis: 424_242
      }

      new_transport_strategy = %StaticTransportStrategy{
        grpc_configuration: new_grpc_configuration
      }

      new_config =
        Momento.Config.Configuration.with_transport_strategy(
          @test_configuration,
          new_transport_strategy
        )

      assert new_config.transport_strategy == new_transport_strategy
      assert new_config.transport_strategy.grpc_configuration == new_grpc_configuration
    end
  end

  #
  #  it('should support overriding client timeout in transport strategy', () => {
  #    const newClientTimeoutMillis = 42;
  #    const expectedTransportStrategy = new StaticTransportStrategy({
  #      grpcConfiguration: new StaticGrpcConfiguration({
  #        deadlineMillis: newClientTimeoutMillis,
  #        maxSessionMemoryMb: testGrpcConfiguration.getMaxSessionMemoryMb(),
  #      }),
  #      maxIdleMillis: testMaxIdleMillis,
  #    });
  #    const configWithNewClientTimeout =
  #      testConfiguration.withClientTimeoutMillis(newClientTimeoutMillis);
  #    expect(configWithNewClientTimeout.getLoggerFactory()).toEqual(
  #      testLoggerFactory
  #    );
  #    expect(configWithNewClientTimeout.getRetryStrategy()).toEqual(
  #      testRetryStrategy
  #    );
  #    expect(configWithNewClientTimeout.getTransportStrategy()).toEqual(
  #      expectedTransportStrategy
  #    );
  #  });
  #
  #  it('should make v1 laptop config available via latest alias', () => {
  #    expect(Configurations.Laptop.latest()).toEqual(Configurations.Laptop.v1());
  #  });
  #  it('should make v1 inregion default config available via latest alias', () => {
  #    expect(Configurations.InRegion.Default.latest()).toEqual(
  #      Configurations.InRegion.Default.v1()
  #    );
  #  });
  #  it('should make v1 inregion low latency config available via latest alias', () => {
  #    expect(Configurations.InRegion.LowLatency.latest()).toEqual(
  #      Configurations.InRegion.LowLatency.v1()
  #    );
  #  });
end
