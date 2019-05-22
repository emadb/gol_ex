defmodule GolExTest do
  use ExUnit.Case
  doctest GolEx

  test "greets the world" do
    assert GolEx.hello() == :world
  end
end
