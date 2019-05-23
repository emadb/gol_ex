defmodule CellTest do
  use ExUnit.Case

  test "alive should return true" do
    GolEx.Cell.start_link({73, 4})
    assert GolEx.Cell.alive?({73, 4}) == {:ok, true}

  end

  test "tick should increase age" do
    GolEx.Cell.start_link({73, 4})
    GolEx.Cell.tick({73, 4})
    assert GolEx.Cell.get_age({73, 4}) == {:ok, 1}
  end
end
