defmodule ElixirGrpcClientTest do
  use ExUnit.Case
  doctest ElixirGrpcClient

  test "greets the world" do
    assert ElixirGrpcClient.hello() == :world
  end
end
