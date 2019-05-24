defmodule CellTest do
  use ExUnit.Case

  test "alive should return true" do
    GolEx.Cell.start_link({73, 4})
    assert GolEx.Cell.alive?({73, 4}) == {:ok, true}

  end

  test "tick should increase age" do
    GolEx.Cell.start_link({73, 8})
    GolEx.Cell.tick({73, 8})
    assert GolEx.Cell.get_age({73, 8}) == {:ok, 1}
  end

  test "apply_tick should kill the cell" do
    cell = {83, 8}
    GolEx.Cell.start_link(cell)
    GolEx.Cell.tick(cell)
    GolEx.Cell.apply_tick(cell)
    assert GolEx.CellRegistry.alive?(cell) == false
  end

  test "apply_tick to a cell with two nieghbours should live the cell" do
    cell = {93, 9}
    GolEx.Cell.start_link(cell)
    GolEx.Cell.start_link({94, 9})
    GolEx.Cell.start_link({93, 10})

    GolEx.Cell.tick(cell)
    GolEx.Cell.apply_tick(cell)
    assert GolEx.CellRegistry.alive?(cell) == true
  end
end
