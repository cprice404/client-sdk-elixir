defmodule ElixierGunclientTest do
  use ExUnit.Case
  doctest ElixierGunclient

  test "greets the world" do
    assert ElixierGunclient.hello() == :world
  end
end
