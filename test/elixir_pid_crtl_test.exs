defmodule ElixirPidCrtlTest do
  use ExUnit.Case
  doctest ElixirPidCrtl

  test "greets the world" do
    assert ElixirPidCrtl.hello() == :world
  end
end
