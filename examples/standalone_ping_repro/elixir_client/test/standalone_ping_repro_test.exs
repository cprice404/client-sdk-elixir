defmodule StandalonePingReproTest do
  use ExUnit.Case
  doctest StandalonePingRepro

  test "greets the world" do
    assert StandalonePingRepro.hello() == :world
  end
end
